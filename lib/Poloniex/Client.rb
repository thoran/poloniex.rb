# Poloniex/Client.rb
# Poloniex::Client

require_relative './V1/Client'

module Poloniex
  class Client < Poloniex::V1::Client; end
end
