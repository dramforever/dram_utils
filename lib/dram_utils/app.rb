require "rack/builder"
require "rack/server"
require "dram_utils/api"
require "dram_utils/home"

module DramUtils
  APP = Rack::Builder.new do
    map("/api") { run API }
    use Home
    run lambda { |*_| [404, {}, "<h1>Not Found</h1>"] }
  end

  def self.run!
    s = Rack::Server.new app: APP
    s.start
  end
end