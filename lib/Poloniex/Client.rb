# Poloniex/Client.rb
# Poloniex::Client

require_relative './V1/Client'

module Poloniex
  class Client < Poloniex::V1::Client

    ALLOWABLE_VERBS = %w{GET POST PUT DELETE}
    API_HOST = 'api.poloniex.com'

  end
end
