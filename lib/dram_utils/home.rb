require "dram_utils/base"
require "haml"

module DramUtils
  class Home < Base
    set :views, File.join(File.dirname(__FILE__), "home_views/")

    get "/" do
      haml :home
    end
  end
end