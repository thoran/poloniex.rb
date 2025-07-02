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
end

# Or configure per client instance
client = Poloniex::Client.new(
  api_key: 'your_api_key',
  api_secret: 'your_api_secret',
  debug: false # nil by default; set to true for debugging output
)
```

### Public API Endpoints

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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yourusername/poloniex.rb.


## Contributing

1. Fork it (https://github.com/thoran/bitget.rb/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new pull request



## License

The gem is available as open source under the terms of the [Ruby License](https://opensource.org/licenses/MIT).
