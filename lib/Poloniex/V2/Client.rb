require 'base64'
require 'fileutils'
gem 'http.rb'; require 'http.rb'
require 'json'
require 'logger'
require 'openssl'

require_relative '../Configuration'
require_relative '../Error'
require_relative '../../Hash/x_www_form_urlencode'

module Poloniex
  module V2
    class Client
      class << self
        def path_prefix
          '/v2'
        end
      end

      # Public endpoints

      ## Reference Data

      ### CurrencyV2 Information
      ### GET https://api.poloniex.com/v2/currencies
      ### GET https://api.poloniex.com/v2/currencies/{currency}
      ### https://api-docs.poloniex.com/spot/api/public/reference-data#currencyv2-information
      def currencies(currency = nil)
        path = '/currencies'
        path = "/currencies/{currency}" if currency
        response = get(path: path)
        handle_response(response)
      end

      # Authenticated endpoints

      ## Wallets

      ### Withdraw Currency V2
      ### POST https://api.poloniex.com/v2/wallets/withdraw
      ### https://api-docs.poloniex.com/spot/api/private/wallet#withdraw-currency-v2
      def withdraw_currency(coin:, network:, amount:, address:, address_tag: nil, allow_borrow: nil)
        response = post(
          path: '/wallets/withdraw',
          args: {
            coin: coin,
            network: network,
            amount: amount,
            address: address,
            addressTag: address_tag,
            allowBorrow: allow_borrow
          }
        )
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
        @debug = !![debug, configuration&.debug, Poloniex.configuration.debug].compact.first
        @logger = logger || configuration&.logger || Poloniex.configuration.logger
      end

      def request_timestamp
        @request_timestamp ||= (Time.now.to_f * 1000).to_i.to_s
      end

      def message(verb:, path:, args: {})
        case verb
        when 'GET'
          args.merge!(signTimestamp: request_timestamp)
          [verb, path, args.x_www_form_urlencode]
        when 'POST', 'PUT', 'DELETE'
          request_body = JSON.generate(args)
          [verb, path, [request_body, request_timestamp].join('&')]
        else
          raise ArgumentError, "Unsupported HTTP verb: #{verb}"
        end.join("\n")
      end

      def signature(message)
        digest = OpenSSL::HMAC.digest('sha256', @api_secret, message)
        Base64.strict_encode64(digest)
      end

      def request_string(path)
        "https://#{Poloniex::Client::API_HOST}#{self.class.path_prefix}#{path}"
      end

      def headers(signature)
        {
          'Content-Type' => 'application/json',
          'key' => @api_key,
          'signatureMethod' => 'HmacSHA256',
          'signature' => signature,
          'signatureVersion' => '2',
          'signTimestamp' => request_timestamp
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
        sorted_args = args.is_a?(Array)? args : args.reject{|_, v| v.nil?}.sort.to_h # create_multiple_order() supplies an array.
        args.merge!(signTimestamp: request_timestamp)
        message = message(verb: verb, path: path, args: sorted_args)
        signature = signature(message)
        headers = headers(signature)
        log_request(verb: verb, request_string: request_string(path), args: sorted_args, headers: headers) if use_logging?
        response = HTTP.send(verb.to_s.downcase, request_string(path), sorted_args, headers)
        @request_timestamp = nil
        response
      end

      def get(path:, args: {})
        do_request(verb: 'GET', path: path, args: args)
      end

      def post(path:, args: {})
        do_request(verb: 'POST', path: path, args: args)
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
              body: response.body
            )
          when 401
            log_error(code: response.code, message: response.message, body: response.body) if use_logging?
            raise Poloniex::AuthenticationError.new(
              code: response.code,
              message: response.message,
              body: response.body
            )
          when 429
            log_error(code: response.code, message: response.message, body: response.body) if use_logging?
            raise Poloniex::RateLimitError.new(
              code: response.code,
              message: response.message,
              body: response.body
            )
          else
            log_error(code: response.code, message: response.message, body: response.body) if use_logging?
            raise Poloniex::APIError.new(
              code: response.code,
              message: response.message,
              body: response.body
            )
          end
        end
      end
    end
  end
end
