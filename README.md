# poloniex.rb

A Ruby wrapper for the Poloniex cryptocurrency exchange API.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'poloniex.rb'
```

And then execute:

```
$ bundle install
```

Or install it yourself as:

```
$ gem install poloniex.rb
```


## Usage

### Configuration

```ruby
# Configure globally
Poloniex.configure do |config|
  config.api_key = 'your_api_key'
  config.api_secret = 'your_api_secret'
  config.debug = false # nil by default; set to true for debugging output
  config.logger = STDOUT # nil by default
end

# Or configure per client instance
client = Poloniex::Client.new(
  api_key: 'your_api_key',
  api_secret: 'your_api_secret',
  debug: false, # nil by default; set to true for debugging output
  logger: STDOUT # nil by default
)

# Or configure per client instance by passing in a configuration object
configuration = Poloniex::Configuration.new(
  api_key: 'your_api_key',
  api_secret: 'your_api_secret',
  debug: false, # nil by default; set to true for debugging output
  logger: STDOUT # nil by default
)
client = Poloniex::Client.new(configuration: configuration)
```

### Public V1 API Endpoints

```ruby
# Get candles for specific symbol
client.candles('BTC_USDT', interval: 'DAY_1', start_time: 1648995780000, end_time: 1649082180000, limit: 10)

# Get all currencies
client.currencies

# Get specific currency
client.currencies('BTC')

# Get mark prices for all symbols
client.mark_prices

# Get mark price for specific symbol
client.mark_prices('BTC_USDT')

# Get mark price components for specific symbol
client.mark_price_components('BTC_USDT')

# Get all markets/symbols
client.markets

# Get specific market/symbol
client.markets('BTC_USDT')

# Get order book for specific symbol
client.order_book('BTC_USDT', scale: '1', limit: 10)

# Get prices for all symbols
client.prices

# Get price for specific symbol
client.prices('BTC_USDT')

# Get 24h ticker for all symbols
client.ticker_24h

# Get 24h ticker for specific symbol
client.ticker_24h('BTC_USDT')

# Get server timestamp
client.timestamp

# Get trades for specific symbol
client.trades('BTC_USDT', limit: 10)
```

### Authenticated V1 API Endpoints

#### Account Endpoints

```ruby
# Account information
client.accounts

# All account balances
client.accounts_balances

# Account activity
client.accounts_activity(limit: 10)

# Accounts transfer
client.accounts_transfer(
  currency: 'USDT',
  amount: 10.5,
  from_account: 'SPOT',
  to_account: 'FUTURES'
)

# Accounts transfer records
client.accounts_transfer_records

# Fee info
client.fee_info

# Interest history
client.accounts_interest_history
```

#### Margin Endpoints
```ruby
# Account margin
client.account_margin

# Borrow status
client.borrow_status

# Borrow status for a particulcar coin
client.borrow_status(currency: 'BTC')

#
client.max_buy_sell_amount('BTC_USDT')
```

#### Order Endpoints
```ruby

# Create order
client.create_order(
  symbol: 'BTC_USDT',
  side: 'BUY',
  type: 'LIMIT',
  quantity: 0.001,
  price: 20_000
)

# Create multiple orders
client.create_multiple_orders(
  [
    {
      symbol: 'BTC_USDT',
      side: 'BUY',
      type: 'LIMIT',
      quantity: 0.01,
      price: 15_000
    },
    {
      symbol: 'BTC_USDT',
      side: 'BUY',
      type: 'LIMIT',
      quantity: 0.1,
      price: 8_000
    }
  ]
)

# Cancel replace order
client.cancel_replace_order(order_id: 'blue')

# Open orders for all symbols
client.open_orders

# Open orders for specific symbol
client.open_orders(symbol: 'BTC_USDT')

# Order details
client.order_details(order_id: '21934611974062080')

# Cancel order
client.cancel_order(order_id: '32487004629499904')

# Cancel multiple orders
client.cancel_multiple_orders(order_ids: ['12345', '67890'])

# Cancel all orders
client.subject.cancel_all_orders(
  symbols: %w{BTC_USDT ETH_USDT},
  account_types: %w{SPOT}
)

# Kill switch
client.subject.kill_switch(timeout: 10)

# Kill switch status
client.subject.kill_switch_status
```

### Wallet Endpoints
```ruby
# Deposit addresses
client.deposit_addresses

# Deposit addresses for specific coin
client.deposit_addresses('BTC')

# Wallets activity records
client.wallets_activity(start: 1754734725, finish: 1754739175)

# New currency address
client.new_currency_address('BTC')

# Withdraw currency
client.withdraw_currency(
  currency: "BTC",
  amount: "0.1",
  address: "1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa"
)
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yourusername/poloniex.rb.


## Contributing

1. Fork it (https://github.com/thoran/poloniex.rb/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new pull request


## License

The gem is available as open source under the terms of the [Ruby License](https://en.wikipedia.org/wiki/Ruby_License).
