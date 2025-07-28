require_relative '../helper'

require 'logger'

describe "Poloniex::Configuration" do
  describe ".configure" do
    subject do
      Poloniex::Client.new
    end

    before do
      Poloniex.configure do |config|
        config.api_key = 'test_api_key'
        config.api_secret = 'test_api_secret'
        config.debug = false
        config.logger = Logger.new('test_log_file')
      end
    end

    it "uses global configuration by default" do
      _(subject.api_key).must_equal('test_api_key')
      _(subject.api_secret).must_equal('test_api_secret')
      _(subject.debug).must_equal(false)
      _(subject.logger).must_be_kind_of(Logger)
    end
  end

  describe "using a configuration object" do
    subject do
      Poloniex::Client.new(configuration: configuration)
    end

    let(:configuration) do
      Poloniex::Configuration.new(
        api_key: 'test_api_key',
        api_secret: 'test_api_secret',
        debug: false,
        logger: Logger.new('test_log_file')
      )
    end

    it "accepts a configuration object as an argument" do
      _(subject.api_key).must_equal('test_api_key')
      _(subject.api_secret).must_equal('test_api_secret')
      _(subject.debug).must_equal(false)
      _(subject.logger).must_be_kind_of(Logger)
    end
  end

  describe "overriding configuration" do
    subject do
      Poloniex::Client.new(
        api_key: 'test_api_key',
        api_secret: 'test_api_secret',
        debug: true,
        logger: Logger.new('test_log_file')
      )
    end

    before do
      class FakeLogger; end
      Poloniex.configure do |config|
        config.api_key = 'overridden_test_api_key'
        config.api_secret = 'overridden_test_api_secret'
        config.debug = false
        config.logger = FakeLogger.new
      end
    end

    it "allows overriding configuration" do
      _(subject.api_key).must_equal('test_api_key')
      _(subject.api_secret).must_equal('test_api_secret')
      _(subject.debug).must_equal(true)
      _(subject.logger).must_be_kind_of(Logger)
    end
  end
end
