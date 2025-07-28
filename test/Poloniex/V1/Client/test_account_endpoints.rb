require_relative '../../../helper'

describe "Poloniex::V1::Client Account Endpoints" do
  let(:api_key){ENV.fetch('POLONIEX_API_KEY', '<API_KEY>')}
  let(:api_secret){ENV.fetch('POLONIEX_API_SECRET', '<API_SECRET>')}

  subject do
    Poloniex::V1::Client.new(
      api_key: api_key,
      api_secret: api_secret
    )
  end

  describe "Account endpoints" do
    it "fetches a list of accounts" do
      VCR.use_cassette('v1/accounts') do
        response = subject.accounts
        _(response).must_be_kind_of(Array)
      end
    end

    it "fetches account balances" do
      VCR.use_cassette('v1/accounts_balances') do
        response = subject.accounts_balances
        _(response).must_be_kind_of(Array)
      end
    end

    it "fetches account activity" do
      VCR.use_cassette('v1/accounts_activity') do
        response = subject.accounts_activity(limit: 10)
        _(response).must_be_kind_of(Array)
      end
    end

    it "fetches account transfers" do
      VCR.use_cassette('v1/accounts_transfer') do
        response = subject.accounts_transfer(
          currency: 'USDT',
          amount: 10.5,
          from_account: 'SPOT',
          to_account: 'FUTURES'
        )
        _(response).must_be_kind_of(Hash)
      end
    end

    it "fetches account transfer records" do
      VCR.use_cassette('v1/accounts_transfer_records') do
        response = subject.accounts_transfer_records
        _(response).must_be_kind_of(Array)
      end
    end

    it "fetches fee info" do
      VCR.use_cassette('v1/fee_info') do
        response = subject.fee_info
        _(response).must_be_kind_of(Hash)
      end
    end

    it "fetches accounts interest history" do
      VCR.use_cassette('v1/accounts_interest_history') do
        response = subject.accounts_interest_history
        _(response).must_be_kind_of(Array)
      end
    end
  end
end
