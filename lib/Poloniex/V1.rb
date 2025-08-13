# Poloniex/V1.rb
# Poloniex::V1

require_relative './V1/Client'

module Poloniex
  module V1
    PUBLIC_PATH_PREFIXES = [
      "/markets",
      "/currencies",
      "/timestamp",
    ].freeze
  end
end
