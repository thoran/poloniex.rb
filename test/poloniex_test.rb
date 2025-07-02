require_relative './helper'

describe Poloniex do
  it "has a version number" do
    _(Poloniex::VERSION).must_be_kind_of(String)
  end

  describe ".configure" do
    it "allows setting configuration values" do
      Poloniex.configure do |config|
        config.api_key = "test_key"
        config.api_secret = "test_secret"
        config.debug = true
        config.logger = './log.txt'
      end

      _(Poloniex.configuration.api_key).must_equal("test_key")
      _(Poloniex.configuration.api_secret).must_equal("test_secret")
      _(Poloniex.configuration.debug).must_equal(true)
      _(Poloniex.configuration.logger).must_equal('./log.txt')
    end
  end
end
