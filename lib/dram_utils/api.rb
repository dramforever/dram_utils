require "sinatra/base"
require "socket"
require "json"
require "net/ping"
require "whois"
require "rack/utils"

require "dram_utils/error"
require "dram_utils/base"

module DramUtils

  ##
  # The +dram_utils+ api
  #
  # All urls are mapped to /api (i.e. /dns becomes /api/dns)
  # if run with +DramUtils.run!+
  class API < Base
    AF_TABLE = Socket.constants.select { |x| x.to_s[0..2] == "AF_" }
    .map { |x| [Socket.const_get(x), x.to_s] }
    .to_h

    ##
    # DNS lookup
    #
    # Parameters:
    # - +host+: required, the host to pass to +TCPSocket.gethostbyname+
    #
    # Successful Response:
    #     {
    #         "status": "success",
    #         "cname": <canonical name of the host>,
    #         "aliases": <array of aliases>,
    #         "af": <address family string (like "AF_INET")>,
    #         "ips": <ip addresses>
    #     }
    #
    # Errors:
    # - Will cause a +DnsLookupError+ if lookup fails
    # - Will cause a +DnsWrongAFError+ if af is not AF_INET or AF_INET6
    get "/dns" do
      required_param :host
      info = TCPSocket.gethostbyname params[:host] rescue halt_with DnsLookupError

      unless AF_TABLE[info[2]].start_with? "AF_INET"
        halt_with DnsWrongAFError
      end

      cname, aliases, af, ip6, ip4 = info
      ips = []
      ips << ip6 if ip6
      ips << ip4 if ip4 and ip6 != ip4

      {
          status: "success",
          cname: cname,
          aliases: aliases,
          af: AF_TABLE[af],
          ips: ips
      }.to_json
    end

    ##
    # HTTP ping
    #
    # Parameters:
    # - +host+: required, the host to ping
    #
    # Successful Response:
    #     {
    #         "status": "success",
    #         "result": <bool indicating if the ping was successful>
    #         "duration": <integer indicating the time took. Will be +null+ if the ping failed>
    #     }
    #
    get "/http_ping" do
      required_param :host
      p = Net::Ping::HTTP.new params[:host]
      p.timeout = 3
      result = p.ping rescue false

      {
          status: "success",
          result: result,
          duration: p.duration
      }.to_json
    end


    WHOIS_CACHE = {}

    ##
    # Whois lookup
    #
    # Parameters:
    # - +host+: required, the host to lookup
    #
    # Because whois records are pretty long, this API returns a
    # URL to see the full record when the lookup is successful,
    # or returns a error message otherwise
    #
    # Successful Response:
    #     {
    #         "status": "success",
    #         "url": <url to see the full record>
    #     }
    #
    # Errors:
    # - Will cause a +WhoisError+ if +Whois.whois+ raises an error
    #
    # Notes:
    # - Will use the data in +WHOIS_CACHE+ if available
    get "/whois" do
      required_param :host

      err = nil
      w = WHOIS_CACHE[params[:host]] ||= Whois.whois(params[:host]) rescue err = $!

      if params[:see]
        if err
          <<END
<pre>
ERROR: #{err.class}
          #{err}
</pre>
END
        else
          "<pre>#{w}</pre>"
        end
      else
        halt_with WhoisError.new(err) if err

        {
            status: "success",
            url: url("/whois?see=true&host=#{Rack::Utils.escape params[:host]}")
        }.to_json
      end
    end

    not_found { halt_with NotFoundError }
  end
end
