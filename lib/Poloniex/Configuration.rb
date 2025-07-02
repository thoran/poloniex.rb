# Poloniex/Configuration.rb
# Poloniex::Configuration

module Poloniex
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def reset_configuration!
      @configuration = Configuration.new
    end
  end # class << self

  class Configuration
    attr_accessor\
      :api_key,
      :api_secret,
      :debug,
      :logger

    def configure
      yield(self)
    end

    def reset!
      @api_key = nil
      @api_secret = nil
      @debug = false
      @logger = nil
    end

    private

    def initialize(api_key: nil, api_secret: nil, debug: nil, logger: nil)
      @api_key = api_key
      @api_secret = api_secret
      @debug = debug
      @logger = logger
    end
  end
end
