require "roleman/version"
require "roleman/authenticator"
require "roleman/router"
require "roleman/route"
require "roleman/config"
require "roleman/parser"
require "roleman/table_converter"
require "roleman/table_converter/markdown"
require "roleman/table_converter/xlsx"
require "roleman/table_converter/yaml"

module Roleman
  class Error < StandardError; end

  def init(config, options={})
    @config = Config.load(config, options)
    @router = Router.new(@config.routes)
    @authenticator = Authenticator.new(config: @config, router: @router)
  end

  def authorize(user, request, extras={})
    raise Error('Please call Roleman.init before use.') unless @authenticator
    @authenticator.authorize(user, request, extras)
  end
end
