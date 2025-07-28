require_relative '../helper'

describe Poloniex::Client do
  let(:api_key){ENV.fetch('POLONIEX_API_KEY', '<API_KEY>')}
  let(:api_secret){ENV.fetch('POLONIEX_API_SECRET', '<API_SECRET>')}

  subject do
    Poloniex::Client.new(
      api_key: api_key,
      api_secret: api_secret
    )
  end

  it "inherits from Poloniex::V1::Client" do
    _(subject).must_be_kind_of(Poloniex::V1::Client)
  end

  it "can make API calls" do
    VCR.use_cassette('v1/markets') do
      _(subject.markets).must_be_kind_of(Array)
    end
  end
end
