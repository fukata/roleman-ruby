module Roleman
  class Router
    attr_reader :routes

    def initialize(routes)
      @routes = routes
    end

    #FIXME optimize lookup algorithm
    def find_route(path, method)
      method = method.upcase
      routes.each do |route|
        next unless route.method == method
        if route.regex && route.regex.match?(path)
          return route
        elsif route.path == path
          return route
        end
      end

      nil
    end
  end
end