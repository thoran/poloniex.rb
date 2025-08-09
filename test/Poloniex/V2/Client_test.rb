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
      VCR.use_cassette('v2/currencies') do
        response = subject.currencies
        _(response).must_be_kind_of(Array)
      end
    end

    it "fetches a specific currency" do
      VCR.use_cassette('v2/currencies_btc') do
        response = subject.currencies('BTC')
        _(response).must_be_kind_of(Hash)
        _(response.count).must_equal(2)
        _(response['BTC']).must_be_kind_of(Hash)
        _(response['BTC']['name']).must_equal('Bitcoin')
      end
    end
  end

  describe "#withdraw_currency" do
    it "performs a withdrawal" do
      VCR.use_cassette('v2/withdraw_currency') do
        response = subject.withdraw_currency(
          coin: 'BTC',
          network: 'BTC',
          amount: 2000,
          address: '131rdg5Rzn6BFufnnQaHhVa5ZtRU1J2EZR'
        )
        _(response).must_be_kind_of(Array)
        _(response).must_be_kind_of(Hash)
        _(response.count).must_equal(1)
        _(response['BTC']).must_be_kind_of(Hash)
        _(response['BTC']['name']).must_equal('Bitcoin')
      end
    end
  end
end
