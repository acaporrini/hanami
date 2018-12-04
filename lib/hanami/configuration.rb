# frozen_string_literal: true

require "concurrent/hash"

module Hanami
  # Hanami application configuration
  #
  # @since 2.0.0
  class Configuration
    require "hanami/configuration/cookies"
    require "hanami/configuration/sessions"
    require "hanami/configuration/middleware"
    require "hanami/configuration/security"

    def initialize
      @settings = Concurrent::Hash.new

      self.routes   = DEFAULT_ROUTES
      self.cookies  = DEFAULT_COOKIES
      self.sessions = DEFAULT_SESSIONS

      self.default_request_format  = DEFAULT_REQUEST_FORMAT
      self.default_response_format = DEFAULT_RESPONSE_FORMAT

      self.middleware = Middleware.new
      self.security   = Security.new
    end

    def routes=(value)
      settings[:routes] = value
    end

    def routes
      settings.fetch(:routes)
    end

    def cookies=(options)
      settings[:cookies] = Cookies.new(options)
    end

    def cookies
      settings.fetch(:cookies)
    end

    def sessions=(*args)
      settings[:sessions] = Sessions.new(args)
    end

    def sessions
      settings.fetch(:sessions)
    end

    def default_request_format=(value)
      settings[:default_request_format] = value
    end

    def default_request_format
      settings.fetch(:default_request_format)
    end

    def default_response_format=(value)
      settings[:default_response_format] = value
    end

    def default_response_format
      settings.fetch(:default_response_format)
    end

    def middleware
      settings.fetch(:middleware)
    end

    def security=(value)
      settings[:security] = value
    end

    def security
      settings.fetch(:security)
    end

    def for_each_middleware(&blk)
      stack = middleware.stack.dup
      stack += sessions.middleware if sessions.enabled?

      stack.each(&blk)
    end

    protected

    def middleware=(value)
      settings[:middleware] = value
    end

    private

    DEFAULT_ROUTES = File.join("config", "routes")
    private_constant :DEFAULT_ROUTES

    DEFAULT_COOKIES = Cookies.null
    private_constant :DEFAULT_COOKIES

    DEFAULT_SESSIONS = Sessions.null
    private_constant :DEFAULT_SESSIONS

    DEFAULT_REQUEST_FORMAT = :html
    private_constant :DEFAULT_REQUEST_FORMAT

    DEFAULT_RESPONSE_FORMAT = :html
    private_constant :DEFAULT_RESPONSE_FORMAT

    attr_reader :settings
  end
end
