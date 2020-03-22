module Roleman
  class Parser
    def initialize(config, options)
      @config = config
      @options = options
    end

    def parse
      config = Config.new
      root = @config['roleman']
      raise ::ArgumentError.new('Not have roleman key in config') unless root
      raise ::ArgumentError.new('roleman value is must be Hash') unless root.is_a? Hash

      config.version = root['version'].to_s
      config.role_field = root['role_field'] || 'role'
      config.routes = []

      root['routes'].each do |r|
        regex = r['regex']
        regex = %r|\A#{regex}\Z| if regex

        # Generate regex from path
        # /users/:id/edit => %r{/users/.+/edit}
        if regex.nil? && r['path'].include?(':')
          re_str = r['path'].gsub(%r{:[^/]+/?}, '[^/]+/').chomp('/')
          regex = %r|\A#{re_str}\Z|
        end

        route = Route.new(
          path: r['path'],
          method: r['method'].upcase,
          regex: regex,
          enabled_roles: Array(r['enabled_roles']).compact,
          disabled_roles: Array(r['disabled_roles']).compact,
        )
        config.routes.push route
      end

      config
    end
  end
end