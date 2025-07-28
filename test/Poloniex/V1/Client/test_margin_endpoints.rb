require_relative '../../../helper'

require 'logger'

describe "Poloniex::V1::Client Margin Endpoints" do
  let(:api_key){ENV.fetch('POLONIEX_API_KEY', '<API_KEY>')}
  let(:api_secret){ENV.fetch('POLONIEX_API_SECRET', '<API_SECRET>')}

  subject do
    Poloniex::V1::Client.new(
      api_key: api_key,
      api_secret: api_secret,
      logger: Logger.new('/Users/thoran/log/poloniex/log.txt'),
      debug: true
    )
  end

  describe "#account_margin" do
    it "fetches margin account info" do
      VCR.use_cassette('v1/margin_account_margin') do
        response = subject.account_margin
        _(response).must_be_kind_of(Hash)
      end
    end
  end

  describe "#borrow_status" do
    it "fetches margin positions" do
      VCR.use_cassette('v1/margin_borrow_status') do
        response = subject.borrow_status
        _(response).must_be_kind_of(Array)
      end
    end

    it "fetches margin positions for specific currency" do
      VCR.use_cassette('v1/magin_borrow_status_btc') do
        response = subject.borrow_status(currency: 'BTC')
        _(response).must_be_kind_of(Array)
      end
    end
  end

  describe "#max_buy_sell_amount" do
    it "creates margin borrow" do
      VCR.use_cassette('v1/max_buy_sell_amount') do
        response = subject.max_buy_sell_amount('BTC_USDT')
        _(response).must_be_kind_of(Hash)
        _(response['symbol']).must_equal('BTC_USDT')
        assert(response['maxLeverage'])
        assert(response['maxAvailableBuy'])
        assert(response['maxAvailableSell'])
        assert(response['availableBuy'])
        assert(response['availableSell'])
      end
    end
  end
end
