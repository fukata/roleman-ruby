module Roleman
  class Route
    attr_reader :path, :method, :regex, :enabled_roles, :disabled_roles

    def initialize(path:, method:, regex:, enabled_roles:, disabled_roles:)
      @path = path
      @method = method
      @regex = regex
      @enabled_roles = enabled_roles
      @disabled_roles = disabled_roles
    end
  end
end