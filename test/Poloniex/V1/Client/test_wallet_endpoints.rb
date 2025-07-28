require_relative '../../../helper'

describe "Poloniex::V1::Client Wallet Endpoints" do
  let(:api_key){ENV.fetch('POLONIEX_API_KEY', '<API_KEY>')}
  let(:api_secret){ENV.fetch('POLONIEX_API_SECRET', '<API_SECRET>')}

  subject do
    Poloniex::V1::Client.new(
      api_key: api_key,
      api_secret: api_secret
    )
  end

  describe "#deposit_addresses" do
    it "fetches deposit addresses" do
      VCR.use_cassette('v1/deposit_addresses') do
        response = subject.deposit_addresses
        assert_kind_of Hash, response
      end
    end

    it "fetches deposit address for specific currency" do
      VCR.use_cassette('v1/deposit_address_btc') do
        response = subject.deposit_addresses('BTC')
        assert_kind_of Hash, response
      end
    end
  end

  describe "#wallets_activity" do
    it "fetches deposit history" do
      VCR.use_cassette('v1/wallets_activity') do
        response = subject.wallets_activity(limit: 10)
        assert_kind_of Hash, response
      end
    end
  end

  describe "#new_currency_address" do
    it "generates new deposit address" do
      VCR.use_cassette('v1/new_currency_address') do
        response = subject.new_currency_address('BTC')
        assert_kind_of Hash, response
      end
    end
  end

  describe "#withdraw_currency" do
    it "creates withdrawal" do
      VCR.use_cassette('v1/withdraw_currency') do
        response = subject.withdraw_currency(
          currency: "BTC",
          amount: "0.001",
          address: "1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa"
        )
        assert_kind_of Hash, response
      end
    end
  end
end
