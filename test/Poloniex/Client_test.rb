require_relative '../helper'

describe Poloniex::Client do
  subject do
    Poloniex::Client.new
  end

  before do
    Poloniex.configure do |config|
      config.api_key = "test_api_key"
      config.api_secret = "test_api_secret"
      config.debug = false
    end
    WebMock.disable_net_connect!(allow_localhost: true)
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
