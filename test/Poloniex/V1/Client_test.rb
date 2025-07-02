require_relative '../../helper'

describe Poloniex::V1::Client do
  subject do
    Poloniex::V1::Client.new
  end

  before do
    Poloniex.configure do |config|
      config.api_key = "test_api_key"
      config.api_secret = "test_api_secret"
      config.debug = false
    end
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  describe ".configuration" do
    context "global configuration" do
      it "uses global configuration by default" do
        client = Poloniex::V1::Client.new
        _(client).must_be_kind_of(Poloniex::V1::Client)
      end
    end

    context "configuration object " do
      it "accepts a configuration object as an argument" do
        configuration = Poloniex::Configuration.new(
          api_key: "test_api_key",
          api_secret: "test_api_secret",
          debug: false
        )
        client = Poloniex::V1::Client.new(configuration: configuration)
        _(client).must_be_kind_of(Poloniex::V1::Client)
      end
    end

    context "" do
      it "allows overriding configuration" do
        client = Poloniex::V1::Client.new(
          api_key: "custom_key",
          api_secret: "custom_secret",
          debug: true
        )
        _(client).must_be_kind_of(Poloniex::V1::Client)
      end
    end
  end

  describe "#candles" do
    it "fetches candles for a specific symbol" do
      VCR.use_cassette('v1/candles_btcusdt') do
        response = subject.order_book('BTC_USDT')
        _(response).must_be_kind_of(Hash)
      end
    end
  end

  describe "#currencies" do
    it "fetches all currencies" do
      VCR.use_cassette("v1/currencies") do
        response = subject.currencies
        _(response).must_be_kind_of(Array)
      end
    end

    it "fetches a specific currency" do
      VCR.use_cassette("v1/currencies_btc") do
        response = subject.currencies('BTC')
        _(response).must_be_kind_of(Hash)
        _(response.count).must_equal(1)
        _(response['BTC']).must_be_kind_of(Hash)
        _(response['BTC']['name']).must_equal('Bitcoin')
      end
    end
  end

  describe "#mark_prices" do
    it "fetches all markets" do
      VCR.use_cassette('v1/mark_prices') do
        response = subject.mark_prices
        _(response).must_be_kind_of(Array)
      end
    end

    it "fetches a specific market" do
      VCR.use_cassette('v1/mark_prices_btcusdt') do
        response = subject.mark_prices('BTC_USDT')
        _(response).must_be_kind_of(Hash)
        _(response.count).must_equal(3)
        _(response['symbol']).must_equal('BTC_USDT')
      end
    end
  end

  describe "#mark_price_components" do
    it "fetches all markets" do
      VCR.use_cassette('v1/mark_price_components') do
        response = subject.mark_price_components('BTC_USDT')
        _(response).must_be_kind_of(Hash)
      end
    end
  end

  describe "#markets" do
    it "fetches all markets" do
      VCR.use_cassette('v1/markets') do
        response = subject.markets
        _(response).must_be_kind_of(Array)
      end
    end

    it "fetches a specific market" do
      VCR.use_cassette('v1/markets_btcusdt') do
        response = subject.markets('BTC_USDT')
        _(response).must_be_kind_of(Array)
        _(response.count).must_equal(1)
        _(response.first['symbol']).must_equal('BTC_USDT')
      end
    end
  end

  describe "#order_book" do
    it "fetches order book for a specific symbol" do
      VCR.use_cassette('v1/order_book_btcusdt') do
        response = subject.order_book('BTC_USDT')
        _(response).must_be_kind_of(Hash)
      end
    end
  end

  describe "#prices" do
    it "fetches prices for all symbols" do
      VCR.use_cassette('v1/prices') do
        response = subject.prices
        _(response).must_be_kind_of(Array)
      end
    end

    it "fetches price for a specific symbol" do
      VCR.use_cassette('v1/prices_btcusdt') do
        response = subject.prices('BTC_USDT')
        _(response).must_be_kind_of(Hash)
      end
    end
  end

  describe "#ticker_24h" do
    it "fetches 24h ticker for all symbols" do
      VCR.use_cassette('v1/ticker_24h') do
        response = subject.ticker_24h
        _(response).must_be_kind_of(Array)
      end
    end

    it "fetches 24h ticker for a specific symbol" do
      VCR.use_cassette('v1/ticker_24h_btcusdt') do
        response = subject.ticker_24h('BTC_USDT')
        _(response).must_be_kind_of(Hash)
      end
    end
  end

  describe "#timestamp" do
    it "fetches server timestamp" do
      VCR.use_cassette("v1/timestamp") do
        response = subject.timestamp
        _(response).must_be_kind_of(Hash)
        _(response["serverTime"]).must_be_kind_of(Integer)
      end
    end
  end

  describe "#trades" do
    it "fetches trades for a specific symbol" do
      VCR.use_cassette('v1/trades_btcusdt') do
        response = subject.order_book('BTC_USDT')
        _(response).must_be_kind_of(Hash)
      end
    end
  end
end
