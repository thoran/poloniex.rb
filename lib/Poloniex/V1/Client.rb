# Poloniex/V1/Client.rb
# Poloniex::V1::Client

require 'base64'
require 'fileutils'
gem 'http.rb'; require 'http.rb'
require 'json'
require 'logger'
require 'openssl'

require_relative '../Configuration'
require_relative '../Error'

module Poloniex
  module V1
    class Client

      API_HOST = 'api.poloniex.com'

      # Get candles for specific symbol
      def candles(symbol, interval: 'DAY_1', start_time: nil, end_time: nil, limit: nil)
        args = {interval: interval, startTime: start_time, endTime: end_time, limit: limit}
        response = get(path: "/markets/#{symbol}/candles", args: args)
        handle_response(response)
      end

      # Get all currencies if no currency specified.
      def currencies(currency = nil)
        path = "/currencies"
        path += "/#{currency}" if currency
        response = get(path: path)
        handle_response(response)
      end

      # Get mark prices for all symbols if no symbol specified.
      def mark_prices(symbol = nil)
        path = '/markets/markPrice'
        path = "/markets/#{symbol}/markPrice" if symbol
        response = get(path: path)
        handle_response(response)
      end

      # Get mark price components for specific symbol
      def mark_price_components(symbol)
        response = get(path: "/markets/#{symbol}/markPriceComponents")
        handle_response(response)
      end

      # Get all markets/symbols if no symbol specified.
      def markets(symbol = nil)
        path = "/markets"
        path += "/#{symbol}"if symbol
        response = get(path: path)
        handle_response(response)
      end

      # Get order book for specific symbol
      def order_book(symbol, scale: nil, limit: nil)
        args = {scale: scale, limit: limit}
        response = get(path: "/markets/#{symbol}/orderBook", args: args)
        handle_response(response)
      end

      # Get prices for all symbols if no symbol specified.
      def prices(symbol = nil)
        path = '/markets/price'
        path = "/markets/#{symbol}/price" if symbol
        response = get(path: path)
        handle_response(response)
      end

      # Get 24h ticker for all symbols if no symbol specified.
      def ticker_24h(symbol = nil)
        path = '/markets/ticker24h'
        path = "/markets/#{symbol}/ticker24h" if symbol
        response = get(path: path)
        handle_response(response)
      end

      # Get server timestamp
      def timestamp
        response = get(path: '/timestamp')
        handle_response(response)
      end

      # Get trades for specific symbol
      def trades(symbol, limit: nil)
        args = {limit: limit}
        response = get(path: "/markets/#{symbol}/trades", args: args)
        handle_response(response)
      end

      attr_accessor\
        :api_key,
        :api_secret,
        :debug,
        :logger

      private

      def initialize(api_key: nil, api_secret: nil, debug: nil, logger: nil, configuration: nil)
        @api_key = api_key || configuration&.api_key || Poloniex.configuration.api_key
        @api_secret = api_secret || configuration&.api_secret || Poloniex.configuration.api_secret
        @debug = debug || configuration&.debug || Poloniex.configuration.debug
        @logger = logger || configuration&.logger || Poloniex.configuration.logger
      end

      def request_timestamp
        @request_timestamp ||= (Time.now.to_i * 1000).to_s
      end

      def message(verb:, path:, args:)
        case verb
        when 'GET'
          if args.empty?
            [request_timestamp, verb, path].join
          else
            query_string = args.x_www_form_urlencode
            [request_timestamp, verb, path, '?', query_string].join
          end
        end
      end

      def signature(message)
        # digest = OpenSSL::Digest.new('SHA256')
        # hmac = OpenSSL::HMAC.digest(digest, @api_secret, message)
        # Base64.strict_encode64(hmac)
        OpenSSL::HMAC.hexdigest(
          'sha256',
          @api_secret,
          message
        )
      end

      def request_string(path)
        "https://#{API_HOST}#{path}"
      end

      def headers(signature)
        {
          'Content-Type' => 'application/json',
          'key' => @api_key,
          'signatureMethod' => 'HmacSHA256',
          'signature' => signature,
          'signatureVersion' => '2',
          'timestamp' => request_timestamp
        }
      end

      def use_logging?
        !@logger.nil?
      end

      def log_args?(args)
        !args.values.all?(&:nil?)
      end

      def log_request(verb:, request_string:, args:, headers:)
        log_string = "#{verb} #{request_string}\n"
        if log_args?(args)
          log_string << "  Args: #{args}\n"
        end
        log_string << "  Headers: #{headers}\n"
        @logger.info(log_string)
      end

      def log_response(code:, message:, body:)
        log_string = "Code: #{code}\n"
        log_string << "Message: #{message}\n"
        log_string << "Body: #{body}\n"
        @logger.info(log_string)
      end

      def log_error(code:, message:, body:)
        log_string = "Code: #{code}\n"
        log_string << "Message: #{message}\n"
        log_string << "Body: #{body}\n"
        @logger.error(log_string)
      end

      def do_request(verb:, path:, args: {})
        sorted_args = args.reject{|_, v| v.nil?}.sort.to_h
        message = message(verb: verb, path: path, args: sorted_args)
        signature = signature(message)
        headers = headers(signature)
        log_request(verb: verb, request_string: request_string(path), args: sorted_args, headers: headers) if use_logging?
        @request_timestamp = nil
        HTTP.send(verb.to_s.downcase, request_string(path), sorted_args, headers)
      end

      def get(path:, args: {})
        do_request(verb: 'GET', path: path, args: args)
      end

      def handle_response(response)
        if response.success?
          parsed_body = JSON.parse(response.body)
          log_response(code: response.code, message: response.message, body: response.body) if use_logging?
          parsed_body
        else
          case response.code.to_i
          when 400
            log_error(code: response.code, message: response.message, body: response.body) if use_logging?
            raise Poloniex::InvalidRequestError.new(
              code: response.code,
              message: response.message,
              body: body
            )
          when 401
            log_error(code: response.code, message: response.message, body: response.body) if use_logging?
            raise Poloniex::AuthenticationError.new(
              code: response.code,
              message: response.message,
              body: body
            )
          when 429
            log_error(code: response.code, message: response.message, body: response.body) if use_logging?
            raise Poloniex::RateLimitError.new(
              code: response.code,
              message: response.message,
              body: body
            )
          else
            log_error(code: response.code, message: response.message, body: response.body) if use_logging?
            raise Poloniex::APIError.new(
              code: response.code,
              message: response.message,
              body: body
            )
          end
        end
      end
    end
  end
end
