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
require_relative '../../Hash/x_www_form_urlencode'

module Poloniex
  module V1
    class Client
      class << self
        def path_prefix
          ''
        end
      end

      # Public endpoints

      ## Reference Data

      ### Symbol Information
      ### GET https://api.poloniex.com/markets
      ### GET https://api.poloniex.com/markets/{symbol}
      ### https://api-docs.poloniex.com/spot/api/public/reference-data#symbol-information
      def markets(symbol = nil)
        path = "/markets"
        path += "/#{symbol}"if symbol
        response = get(path: path)
        handle_response(response)
      end

      ### Currency Information
      ### GET https://api.poloniex.com/currencies
      ### GET https://api.poloniex.com/currencies/{currency}
      ### https://api-docs.poloniex.com/spot/api/public/reference-data#currency-information
      def currencies(currency = nil, include_multichain_currencies: nil)
        args = {}
        args.merge!(includeMultiChainCurrencies: include_multichain_currencies) if include_multichain_currencies
        path = '/currencies'
        path += "/#{currency}" if currency
        response = get(path: path, args: args)
        handle_response(response)
      end

      ### System Timestamp
      ### GET https://api.poloniex.com/v2/currencies
      ### GET https://api.poloniex.com/v2/currencies/{currency}
      ### https://api-docs.poloniex.com/spot/api/public/reference-data#system-timestamp
      def timestamp
        response = get(path: '/timestamp')
        handle_response(response)
      end

      ## Market Data

      ### Prices
      ### GET https://api.poloniex.com/markets/price
      ### GET https://api.poloniex.com/markets/{symbol}/price
      ### https://api-docs.poloniex.com/spot/api/public/market-data#prices
      def price(symbol = nil)
        path = '/markets/price'
        path = "/markets/#{symbol}/price" if symbol
        response = get(path: path)
        handle_response(response)
      end

      ### Mark Price
      ### GET https://api.poloniex.com/markets/markPrice
      ### GET https://api.poloniex.com/markets/{symbol}/markPrice
      ### https://api-docs.poloniex.com/spot/api/public/market-data#mark-price
      def mark_price(symbol = nil)
        path = '/markets/markPrice'
        path = "/markets/#{symbol}/markPrice" if symbol
        response = get(path: path)
        handle_response(response)
      end

      ### Mark Price Components
      ### GET https://api.poloniex.com/markets/{symbol}/markPriceComponents
      ### https://api-docs.poloniex.com/spot/api/public/market-data#mark-price-components
      def mark_price_components(symbol)
        response = get(path: "/markets/#{symbol}/markPriceComponents")
        handle_response(response)
      end

      ### Order Book
      ### GET https://api.poloniex.com/markets/{symbol}/orderBook
      ### https://api-docs.poloniex.com/spot/api/public/market-data#order-book
      def order_book(symbol, scale: nil, limit: nil)
        response = get(
          path: "/markets/#{symbol}/orderBook",
          args: {
            scale: scale,
            limit: limit
          }
        )
        handle_response(response)
      end

      ### Candles
      ### GET https://api.poloniex.com/markets/{symbol}/candles
      ### https://api-docs.poloniex.com/spot/api/public/market-data#candles
      ### interval: The unit of time by which to aggregate data. Valid values are: MINUTE_1, MINUTE_5, MINUTE_10, MINUTE_15, MINUTE_30, HOUR_1, HOUR_2, HOUR_4, HOUR_6, HOUR_12, DAY_1, DAY_3, WEEK_1 and MONTH_1.
      def candles(symbol, interval: 'DAY_1', start_time: nil, end_time: nil, limit: nil)
        response = get(
          path: "/markets/#{symbol}/candles",
          args: {
            interval: interval,
            startTime: start_time,
            endTime: end_time,
            limit: limit
          }
        )
        handle_response(response)
      end

      ### Trades
      ### GET https://api.poloniex.com/markets/{symbol}/trades
      ### https://api-docs.poloniex.com/spot/api/public/market-data#trades
      def trades(symbol, limit: nil)
        response = get(
          path: "/markets/#{symbol}/trades",
          args: {limit: limit}
        )
        handle_response(response)
      end

      ### Ticker
      ### GET https://api.poloniex.com/markets/ticker24h
      ### GET https://api.poloniex.com/markets/{symbol}/ticker24h
      ### https://api-docs.poloniex.com/spot/api/public/market-data#ticker
      def ticker_24h(symbol = nil)
        path = '/markets/ticker24h'
        path = "/markets/#{symbol}/ticker24h" if symbol
        response = get(path: path)
        handle_response(response)
      end

      ## Margin

      ### Collateral Info
      ### GET https://api.poloniex.com/markets/collateralInfo
      ### GET https://api.poloniex.com/markets/{currency}/collateralInfo
      ### https://api-docs.poloniex.com/spot/api/public/margin#collateral-info
      def collateral_info(currency = nil)
        path = '/markets/collateralInfo'
        path = "/markets/#{currency}/collateralInfo" if currency
        response = get(path: path)
        handle_response(response)
      end

      ### Borrow Rates Info
      ### GET https://api.poloniex.com/markets/borrowRatesInfo
      ### https://api-docs.poloniex.com/spot/api/public/margin#borrow-rates-info
      def borrow_rates_info
        response = get(path: '/markets/borrowRatesInfo')
        handle_response(response)
      end

      # Authenticated endpoints

      ## Account

      ### Account Information
      ### GET https://api.poloniex.com/accounts
      ### https://api-docs.poloniex.com/spot/api/private/account#account-activity
      def accounts
        response = get(path: '/accounts')
        handle_response(response)
      end

      ### All Account Balances
      ### GET https://api.poloniex.com/accounts/balances
      ### GET https://api.poloniex.com/accounts/{id}/balances
      ### https://api-docs.poloniex.com/spot/api/private/account#account-activity
      def accounts_balances(account_id: nil, account_type: nil)
        path = '/accounts/balances'
        path = "/accounts/#{account_id}/balances" if account_id
        response = get(path: path, args: {accountType: account_type})
        handle_response(response)
      end

      ### Account Activity
      ### GET https://api.poloniex.com/accounts/activity
      ### https://api-docs.poloniex.com/spot/api/private/account#account-activity
      def accounts_activity(start_time: nil, end_time: nil, acivity_type: nil, limit: nil, from: nil, direction: nil, currency: nil)
        response = get(
          path: '/accounts/activity',
          args: {
            startTime: start_time,
            endTime: end_time,
            acivityType: acivity_type,
            limit: limit,
            from: from,
            direction: direction,
            currency: currency
          }
        )
        handle_response(response)
      end

      ### Accounts Transfer
      ### POST https://api.poloniex.com/accounts/transfer
      ### https://api-docs.poloniex.com/spot/api/private/account#accounts-transfer
      def accounts_transfer(currency:, amount:, from_account:, to_account:)
        response = post(
          path: '/accounts/transfer',
          args: {
            currency: currency,
            amount: amount,
            fromAccount: from_account,
            toAccount: to_account
          }
        )
        handle_response(response)
      end

      ### Accounts Transfer Records
      ### GET https://api.poloniex.com/accounts/transfer
      ### GET https://api.poloniex.com/accounts/transfer/{id}
      ### https://api-docs.poloniex.com/spot/api/private/account#accounts-transfer-records
      def accounts_transfer_records(transfer_id: nil, limit: nil, from: nil, direction: nil, currency: nil, start_time: nil, end_time: nil)
        path = '/accounts/transfer'
        path += "/#{transfer_id}" if transfer_id
        response = get(
          path: path,
          args: {
            limit: limit,
            from: from,
            direction: direction,
            currency: currency,
            startTime: start_time,
            endTime: end_time
          }
        )
        handle_response(response)
      end

      ### Fee Info
      ### GET https://api.poloniex.com/feeinfo
      ### https://api-docs.poloniex.com/spot/api/private/account#fee-info
      ### Should it be called accounts_fee_info?
      def fee_info
        response = get(path: '/feeinfo')
        handle_response(response)
      end

      ### Interest History
      ### GET https://api.poloniex.com/accounts/interest/history
      ### https://api-docs.poloniex.com/spot/api/private/account#interest-history
      def accounts_interest_history(limit: nil, from: nil, direction: nil, start_time: nil, end_time: nil)
        response = get(
          path: '/accounts/interest/history',
          args: {
            limit: limit,
            from: from,
            direction: direction,
            startTime: start_time,
            endTime: end_time
          }
        )
        handle_response(response)
      end

      ## Wallet

      ### Deposit Addresses
      ### GET https://api.poloniex.com/wallets/addresses
      ### https://api-docs.poloniex.com/spot/api/private/wallet#deposit-addresses
      def deposit_addresses(currency = nil)
        response = get(path: '/wallets/addresses', args: {currency: currency})
        handle_response(response)
      end

      ### Wallets Activity Records
      ### GET https://api.poloniex.com/wallets/activity
      ### https://api-docs.poloniex.com/spot/api/private/wallet#wallets-activity-records
      def wallets_activity(start:, finish:, activity_type: nil)
        response = get(
          path: '/wallets/activity',
          args: {
            start: start,
            end: finish,
            activityType: activity_type
          }
        )
        handle_response(response)
      end

      ### New Currency Address
      ### POST https://api.poloniex.com/wallets/address
      ### https://api-docs.poloniex.com/spot/api/private/wallet#new-currency-address
      def new_currency_address(currency)
        response = post(path: '/wallets/address', args: {currency: currency})
        handle_response(response)
      end

      ### Withdraw Currency
      ### POST https://api.poloniex.com/wallets/withdraw
      ### https://api-docs.poloniex.com/spot/api/private/wallet#withdraw-currency
      def withdraw_currency(currency:, amount:, address:, payment_id: nil, allow_borrow: nil)
        response = post(
          path: '/wallets/withdraw',
          args: {
            currency: currency,
            amount: amount,
            address: address,
            paymentId: payment_id,
            allowBorrow: allow_borrow
          }
        )
        handle_response(response)
      end

      ## Margin

      ### Account Margin
      ### GET https://api.poloniex.com/margin/accountMargin
      ### https://api-docs.poloniex.com/spot/api/private/margin#account-margin
      ### account_type: Currently only SPOT is supported.
      def account_margin(account_type: 'SPOT')
        response = get(path: '/margin/accountMargin', args: {accountType: account_type})
        handle_response(response)
      end

      ### Borrow Status
      ### GET https://api.poloniex.com/margin/borrowStatus
      ### https://api-docs.poloniex.com/spot/api/private/margin#borrow-status
      def borrow_status(currency: nil)
        response = get(path: '/margin/borrowStatus', args: {currency: currency})
        handle_response(response)
      end

      ### Maximum Buy/Sell Amount
      ### GET https://api.poloniex.com/margin/maxSize
      ### https://api-docs.poloniex.com/spot/api/private/margin#maximum-buysell-amount
      def max_buy_sell_amount(symbol)
        response = get(path: '/margin/maxSize', args: {symbol: symbol})
        handle_response(response)
      end

      ## Orders

      ### Create Order
      ### POST https://api.poloniex.com/orders
      ### https://api-docs.poloniex.com/spot/api/private/order#create-order
      def create_order(
        symbol:,
        side:,
        time_in_force: nil,
        type: nil,
        account_type: nil,
        price: nil,
        quantity: nil,
        amount: nil,
        client_order_id: nil,
        allow_borrow: nil,
        stp_mode: nil,
        slippage_tolerance: nil
      )
        response = post(
          path: '/orders',
          args: {
            symbol: symbol,
            side: side,
            timeInForce: time_in_force,
            type: type,
            accountType: account_type,
            price: price,
            quantity: quantity,
            amount: amount,
            clientOrderId: client_order_id,
            allowBorrow: allow_borrow,
            stpMode: stp_mode,
            slippageTolerance: slippage_tolerance,
          }
        )
        handle_response(response)
      end

      ### Create Multiple Orders
      ### POST https://api.poloniex.com/orders/batch
      ### https://api-docs.poloniex.com/spot/api/private/order#create-multiple-orders
      # Need to fix http.rb first as I can't set the body by any other means than via a hash of arguments and that isn't suitable for this method.
      # def create_multiple_orders(orders)
      #   response = post(path: '/orders/batch', args: orders)
      #   handle_response(response)
      # end

      ### Cancel Replace Order
      ### PUT https://api.poloniex.com/orders/{id}
      ### PUT https://api.poloniex.com/orders/cid:{clientOrderId}
      ### https://api-docs.poloniex.com/spot/api/private/order#cancel-replace-order
      def cancel_replace_order(
        order_id: nil,
        client_order_id: false,
        price: nil,
        quantity: nil,
        amount: nil,
        type: nil,
        time_in_force: nil,
        allow_borrow: nil,
        proceed_on_failure: nil,
        slippage_tolerance: nil
      )
        path = "/orders/#{order_id}"
        path = "/orders/cid:#{order_id}" if client_order_id
        args = {
          price: price,
          quantity: quantity,
          amount: amount,
          type: type,
          timeInForce: time_in_force,
          allowBorrow: allow_borrow,
          proceedOnFailure: proceed_on_failure,
          slippageTolerance: slippage_tolerance,
        }
        args.merge!(clientOrderId: order_id) if client_order_id
        response = put(path: path, args: args)
        handle_response(response)
      end

      ### Open Orders
      ### GET https://api.poloniex.com/orders
      ### https://api-docs.poloniex.com/spot/api/private/order#open-orders
      def open_orders(symbol: nil, side: nil, from: nil, direction: nil, limit: nil)
        response = get(
          path: '/orders',
          args: {
            symbol: symbol,
            side: side,
            from: from,
            direction: direction,
            limit: limit
          }
        )
        handle_response(response)
      end

      ### Order Details
      ### GET https://api.poloniex.com/orders/{id}
      ### GET https://api.poloniex.com/orders/cid:{clientOrderId}
      ### https://api-docs.poloniex.com/spot/api/private/order#order-details
      def order_details(order_id:, client_order_id: false)
        path = "/orders/#{order_id}"
        path = "/orders/cid:#{order_id}" if client_order_id
        response = get(path: path, args: {id: order_id})
        handle_response(response)
      end

      ### Cancel Order by Id
      ### DELETE https://api.poloniex.com/orders/{id}
      ### DELETE https://api.poloniex.com/orders/cid:{clientOrderId}
      ### https://api-docs.poloniex.com/spot/api/private/order#cancel-order-by-id
      def cancel_order(order_id:, client_order_id: false)
        path = "/orders/#{order_id}"
        path = "/orders/cid:#{order_id}" if client_order_id
        response = delete(path: path, args: {id: order_id})
        handle_response(response)
      end

      ### Cancel Multiple Orders by Ids
      ### DELETE https://api.poloniex.com/orders/cancelByIds
      ### https://api-docs.poloniex.com/spot/api/private/order#cancel-multiple-orders-by-ids
      def cancel_multiple_orders(order_ids: nil, client_order_ids: nil)
        response = delete(
          path: '/orders/cancelByIds',
          args: {
            orderIds: order_ids,
            clientOrderIds: client_order_ids
          }
        )
        handle_response(response)
      end

      ### Cancel All Orders
      ### DELETE https://api.poloniex.com/orders
      ### https://api-docs.poloniex.com/spot/api/private/order#cancel-all-orders
      def cancel_all_orders(symbols: nil, account_types: nil)
        response = delete(
          path: '/orders',
          args: {
            symbols: symbols,
            accountTypes: account_types
          }
        )
        handle_response(response)
      end

      ### Kill Switch
      ### POST https://api.poloniex.com/orders/killSwitch
      ### https://api-docs.poloniex.com/spot/api/private/order#kill-switch
      def kill_switch(timeout:)
        response = post(path: '/orders/killSwitch', args: {timeout: timeout})
        handle_response(response)
      end

      ### Kill Switch Status
      ### GET https://api.poloniex.com/orders/killSwitchStatus
      ### https://api-docs.poloniex.com/spot/api/private/order#kill-switch-status
      def kill_switch_status
        response = get(path: '/orders/killSwitchStatus')
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

      def message(verb:, path:, sorted_args_with_timestamp: {}, sorted_args_without_timestamp: {})
        case verb
        when 'GET', 'DELETE'
          [verb, path, sorted_args_with_timestamp.x_www_form_urlencode]
        when 'POST', 'PUT'
          request_body = JSON.generate(sorted_args_without_timestamp)
          [verb, path, "requestBody=#{request_body}&signTimestamp=#{request_timestamp}"]
        else
          raise ArgumentError, "Unsupported HTTP verb: #{verb}"
        end.join("\n")
      end

      def signature(message)
        digest = OpenSSL::HMAC.digest('sha256', @api_secret, message)
        Base64.strict_encode64(digest)
      end

      def request_string(path, verb)
        case verb
        when 'GET', 'DELETE'
          "https://#{Poloniex::Client::API_HOST}#{self.class.path_prefix}#{path}"
        when 'POST', 'PUT'
          timestamp_param = {signTimestamp: request_timestamp}.x_www_form_urlencode
          "https://#{Poloniex::Client::API_HOST}#{self.class.path_prefix}#{path}?#{timestamp_param}"
        end
      end

      def headers(signature)
        {
          'Content-Type' => 'application/json',
          'key' => @api_key,
          'signature' => signature,
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
        raise ArgumentError, "Unsupported HTTP verb: #{verb}" unless ['GET', 'POST', 'PUT', 'DELETE'].include?(verb)
        args = args.is_a?(Array)? args : args.reject{|_, v| v.nil?} # create_multiple_orders() supplies an array.
        args_with_timestamp = args.merge(signTimestamp: request_timestamp)
        sorted_args_with_timestamp = args_with_timestamp.sort.to_h
        sorted_args_without_timestamp = args.sort.to_h
        message = message(verb: verb, path: path, sorted_args_with_timestamp: sorted_args_with_timestamp, sorted_args_without_timestamp: sorted_args_without_timestamp)
        @logger.info("Signature message:\n#{message}") if use_logging?
        signature = signature(message)
        headers = headers(signature)
        case verb
        when 'GET', 'DELETE'
          log_request(verb: verb, request_string: request_string(path, verb), args: sorted_args_with_timestamp, headers: headers) if use_logging?
          response = HTTP.send(verb.to_s.downcase, request_string(path, verb), sorted_args_with_timestamp, headers)
        when 'POST', 'PUT'
          log_request(verb: verb, request_string: request_string(path, verb), args: sorted_args_without_timestamp, headers: headers) if use_logging?
          response = HTTP.send(verb.to_s.downcase, request_string(path, verb), sorted_args_without_timestamp, headers)
        end
        @request_timestamp = nil
        response
      end

      def get(path:, args: {})
        do_request(verb: 'GET', path: path, args: args)
      end

      def post(path:, args: {})
        do_request(verb: 'POST', path: path, args: args)
      end

      def delete(path:, args: {})
        do_request(verb: 'DELETE', path: path, args: args)
      end

      def put(path:, args: {})
        do_request(verb: 'PUT', path: path, args: args)
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
