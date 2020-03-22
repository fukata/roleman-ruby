require 'yaml'

module Roleman
  class Config
    attr_accessor :raise_unknown_path
    attr_accessor :version
    attr_accessor :routes
    attr_accessor :role_field

    def self.load(config, options)
      parser = Parser.new(load_config_file(config), options)
      parser.parse
    end

    private
    def self.load_config_file(config)
      case config
      when String
        YAML.load_file(config)
      when Hash
        config
      else
        raise ArgumentError("config is must be String or Hash")
      end
    end
  end
end