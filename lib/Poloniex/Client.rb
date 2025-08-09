# Poloniex/Client.rb
# Poloniex::Client

require_relative './V1/Client'
require_relative './V2/Client'

module Poloniex
  class Client

    ALLOWABLE_VERBS = %w{GET POST PUT DELETE}
    API_HOST = 'api.poloniex.com'

    # Public endpoints

    ## Reference Data

    ### Get all markets/symbols if no symbol specified.
    def markets(symbol = nil)
      v1_client.markets(symbol)
    end

    ### Get all currencies if no currency specified.
    def currencies(currency = nil, include_multichain_currencies: nil)
      v2_client.currencies(currency, include_multichain_currencies: include_multichain_currencies)
    end

    ### Get server timestamp
    def timestamp
      v1_client.timestamp
    end

    ## Market Data

    ### Get prices for all symbols if no symbol specified.
    def price(symbol = nil)
      v1_client.price(symbol)
    end

    ### Get mark prices for all symbols if no symbol specified.
    def mark_price(symbol = nil)
      v1_client.mark_price(symbol)
    end

    ### Get mark price components for specific symbol
    def mark_price_components(symbol)
      v1_client.mark_price_components(symbol)
    end

    ### Get order book for specific symbol
    def order_book(symbol, scale: nil, limit: nil)
      v1_client.order_book(symbol, scale: scale, limit: limit)
    end

    ### Get candles for specific symbol
    def candles(symbol, interval: '1d', start_time: nil, end_time: nil, limit: nil)
      v1_client.candles(symbol, interval: interval, start_time: start_time, end_time: end_time, limit: limit)
    end

    ### Get trades for specific symbol
    def trades(symbol, limit: nil)
      v1_client.trades(symbol, limit: limit)
    end

    ### Get 24h ticker for all symbols if no symbol specified.
    def ticker_24h(symbol = nil)
      v1_client.ticker_24h(symbol)
    end

    ## Margin

    def collateral_info(currency = nil)
      v1_client.collateral_info(currency)
    end

    def borrow_rates_info
      v1_client.borrow_rates_info
    end

    # Authenticated endpoints

    ## Account

    def accounts
      v1_client.accounts
    end

    def accounts_balances(account_id: nil, account_type: nil)
      v1_client.accounts_balances(account_id: account_id, account_type: account_type)
    end

    def accounts_activity(start_time: nil, end_time: nil, acivity_type: nil, limit: nil, from: nil, direction: nil, currency: nil)
      v1_client.accounts_activity(
        start_time: start_time,
        end_time: end_time,
        acivity_type: acivity_type,
        limit: limit,
        from: from,
        direction: direction,
        currency: currency
      )
    end

    def accounts_transfer(currency:, amount:, from_account:, to_account:)
      v1_client.accounts_transfer(
        currency: currency,
        amount: amount,
        from_account: from_account,
        to_account: to_account
      )
    end

    def accounts_transfer_records(transfer_id: nil, limit: nil, from: nil, direction: nil, currency: nil, start_time: nil, end_time: nil)
      v1_client.accounts_transfer_records(
        transfer_id: transfer_id,
        limit: limit,
        from: from,
        direction: direction,
        currency: currency,
        start_time: start_time,
        end_time: end_time
      )
    end

    def fee_info
      v1_client.fee_info
    end

    def accounts_interest_history(limit: nil, from: nil, direction: nil, start_time: nil, end_time: nil)
      v1_client.accounts_interest_history(
        limit: nil,
        from: nil,
        direction: nil,
        start_time: nil,
        end_time: nil
      )
    end

    ## Wallet

    def deposit_addresses(currency = nil)
      v1_client.deposit_addresses(currency)
    end

    def wallets_activity(start:, finish:, activity_type: nil)
      v1_client.wallets_activity(start: start, end: finish, activity_type: activity_type)
    end

    def new_currency_address(currency)
      v1_client.new_currency_address(currency)
    end

    def withdraw_currency(coin:, network:, amount:, address:, address_tag: nil, allow_borrow: nil)
      v2_client.withdraw_currency(
        coin: coin,
        network: network,
        amount: amount,
        address: address,
        address_tag: address_tag,
        allow_borrow: allow_borrow
      )
    end

    ## Margin

    def account_margin(account_type:)
      v1_client.account_margin(account_type: account_type)
    end

    def borrow_status(currency: nil)
      v1_client.borrow_status(currency: currency)
    end

    def max_buy_sell_amount(symbol)
      v1_client.max_buy_sell_amount(symbol)
    end

    ## Orders

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
      v1_client.create_order(
        symbol: symbol,
        side: side,
        time_in_force: time_in_force,
        type: type,
        account_type: account_type,
        price: price,
        quantity: quantity,
        amount: amount,
        client_order_id: client_order_id,
        allow_borrow: allow_borrow,
        stp_mode: stp_mode,
        slippage_tolerance: slippage_tolerance,
      )
    end

    def create_multiple_orders(orders)
      v1_client.create_multiple_orders(orders)
    end

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
      v1_client.cancel_replace_order(
        price: price,
        quantity: quantity,
        amount: amount,
        type: type,
        time_in_force: time_in_force,
        allow_borrow: allow_borrow,
        proceed_on_failure: proceed_on_failure,
        slippage_tolerance: slippage_tolerance,
      )
    end

    def open_orders(symbol: nil, side: nil, from: nil, direction: nil, limit: nil)
      v1_client.open_orders(
        symbol: symbol,
        side: side,
        from: from,
        direction: direction,
        limit: limit
      )
    end

    def order_details(order_id:, client_order_id: false)
      v1_client.order_details(order_id: order_id, client_order_id: client_order_id)
    end

    def cancel_order(order_id:, client_order_id: false)
      v1_client.cancel_order(order_id: order_id, client_order_id: client_order_id)
    end

    def cancel_multiple_orders(order_ids: nil, client_order_ids: nil)
      v1_client.cancel_multiple_orders(order_ids: order_ids, client_order_ids: client_order_ids)
    end

    def cancel_all_orders(symbols: nil, account_types: nil)
      v1_client.cancel_all_orders(symbols: symbols, account_types: account_types)
    end

    def kill_switch(timeout:)
      v1_client.kill_switch(timeout: timeout)
    end

    def kill_switch_status
      v1_client.kill_switch_status
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

    def v1_client
      @v1_client ||= Poloniex::V1::Client.new(
        api_key: @api_key,
        api_secret: @api_secret,
        debug: @debug,
        logger: @logger
      )
    end

    def v2_client
      @v2_client ||= Poloniex::V2::Client.new(
        api_key: @api_key,
        api_secret: @api_secret,
        debug: @debug,
        logger: @logger
      )
    end
  end
end
