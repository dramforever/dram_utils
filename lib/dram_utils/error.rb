require "json"
require "sinatra/base"

module DramUtils

  ##
  # Just +halt_with+ and +required_param+
  module ErrorHelpers

    ##
    # Halts with the json of error +err+
    #
    # +err+ can be either an instance or a class
    def halt_with(err)
      err = err.new if err.is_a? Class
      halt [400, err.to_json]
    end

    ##
    # Ensures that parameter +par+ is given
    def required_param(par)
      params[par] or halt_with MissingParamError.new par.to_s
    end
  end

  ##
  # Used only in the +not_found+ handler
  class NotFoundError < Exception
    def to_json
      {
          status: "error",
          error: {
              type: "not_found",
              msg: "No such API. ",
              details: {}
          }
      }.to_json
    end
  end

  ##
  # Used when a required parameter is missing
  class MissingParamError < Exception

    ##
    # +par_name+: The name of the missing parameter
    def initialize(par_name)
      @par_name = par_name
    end

    def to_json
      {
          status: "error",
          error: {
              type: "missing_parameter",
              msg: "Required parameter #{@par_name} missing. ",
              details: {name: @par_name}
          }
      }.to_json
    end
  end

  ##
  # Used in /api/dns when lookup fails
  class DnsLookupError
    def to_json
      {
          status: "error",
          error: {
              type: "dns_lookup_error",
              msg: "DNS lookup failed",
              details: {}
          }
      }.to_json
    end
  end

  ##
  # Used in /api/whois when +Whois.whois+ raises an error
  class WhoisError

    ##
    # Just pass in the raised error as +err+
    def initialize(err)
      @err = err
    end

    def to_json
      {
          status: "error",
          error: {
              type: "whois_error",
              msg: "Whois failed",
              details: {
                  error_class: @err.class.to_s,
                  error_msg: @err.to_s
              }
          }
      }.to_json
    end
  end
end