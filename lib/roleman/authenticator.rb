module Roleman
  class Authenticator

    # Initialize
    # @param [Config] Config instance
    # @param [Router] Router instance
    def initialize(config:, router:)
      @config = config
      @router = router
    end

    # Authorize user has role for request path and method
    # @param [User,Hash] user User Model
    # @param [path] Request path
    # @param [ActionDispatch::Request] Request Object
    # @param [Hash] extras Extra values for authorize
    def authorize(user, path: nil, request: nil, method: 'GET', extras: {})
      path = get_path(path: path, request: request)
      route = @router.find_route(path, method)

      unless route
        if @config.raise_unknown_path
          @config.raise_unknown_path.call(user, request)
          return
        else
          return true
        end
      end

      role = get_role(user, @config.role_field)
      if route.enabled_roles.include?(role)
        return true
      else
        return false
      end
    end

    private

    # Extract role value from user object
    # @param [String,Hash,User] user User Model
    # @param [String] field role field of user
    def get_role(user, field='role')
      case user
      when String
        user
      when Hash
        user[field] || user[field.to_sym]
      else
        user.send(field.to_sym)
      end
    end

    # Extract path from request object.
    # @param [String] path Request path
    # @param [ActionDispatch::Request] request Request object
    # @return [String] Request path
    # @exception [ArgumentError]
    #   - path and request is nil
    #   - request is not have path property
    def get_path(path: nil, request: nil)
      raise ArgumentError('path or request is must not be nil') unless path || request

      if request
        if request.respond_to? :path
          request.path
        else
          raise ArgumentError('request is not have path property or method')
        end
      else
        path
      end
    end
  end
end