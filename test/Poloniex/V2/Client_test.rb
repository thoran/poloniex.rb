require_relative '../../helper'

describe Poloniex::V2::Client do
  let(:api_key){ENV.fetch('POLONIEX_API_KEY', '<API_KEY>')}
  let(:api_secret){ENV.fetch('POLONIEX_API_SECRET', '<API_SECRET>')}

  subject do
    Poloniex::V2::Client.new(
      api_key: api_key,
      api_secret: api_secret
    )
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

  describe "#withdraw_currency" do
    it "fetches all currencies" do
      VCR.use_cassette('v1/withdraw_currency') do
        response = subject.withdraw_currency(
          coin:,
          network:,
          amount:,
          address:
        )
        _(response).must_be_kind_of(Array)
      end
    end

    it "fetches a specific currency" do
      VCR.use_cassette('v1/currencies_btc') do
        response = subject.withdraw_currency('BTC')
        _(response).must_be_kind_of(Hash)
        _(response.count).must_equal(1)
        _(response['BTC']).must_be_kind_of(Hash)
        _(response['BTC']['name']).must_equal('Bitcoin')
      end
    end
  end
end
