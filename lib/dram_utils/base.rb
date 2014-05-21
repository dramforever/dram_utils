require "sinatra/base"

module DramUtils

  ##
  # Boilerplate for +dram_utils+ classes
  class Base < Sinatra::Base
    helpers ErrorHelpers
  end
end