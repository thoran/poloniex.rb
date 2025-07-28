require_relative '../../../helper'

describe "Poloniex::V1::Client Public Endpoints" do
  let(:api_key){ENV.fetch('POLONIEX_API_KEY', '<API_KEY>')}
  let(:api_secret){ENV.fetch('POLONIEX_API_SECRET', '<API_SECRET>')}

  subject do
    Poloniex::V1::Client.new(
      api_key: api_key,
      api_secret: api_secret
    )
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
      VCR.use_cassette('v1/currencies') do
        response = subject.currencies
        _(response).must_be_kind_of(Array)
      end
    end

    it "fetches a specific currency" do
      VCR.use_cassette('v1/currencies_btc') do
        response = subject.currencies('BTC')
        _(response).must_be_kind_of(Hash)
        _(response.count).must_equal(1)
        _(response['BTC']).must_be_kind_of(Hash)
        _(response['BTC']['name']).must_equal('Bitcoin')
      end
    end
  end

  describe "#mark_price" do
    it "fetches all markets" do
      VCR.use_cassette('v1/mark_price') do
        response = subject.mark_price
        _(response).must_be_kind_of(Array)
      end
    end

    it "fetches a specific market" do
      VCR.use_cassette('v1/mark_price_btcusdt') do
        response = subject.mark_price('BTC_USDT')
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

  describe "#price" do
    it "fetches prices for all symbols" do
      VCR.use_cassette('v1/price') do
        response = subject.price
        _(response).must_be_kind_of(Array)
      end
    end

    it "fetches price for a specific symbol" do
      VCR.use_cassette('v1/price_btcusdt') do
        response = subject.price('BTC_USDT')
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
      VCR.use_cassette('v1/timestamp') do
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
