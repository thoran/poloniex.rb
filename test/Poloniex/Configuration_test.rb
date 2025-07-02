require_relative '../helper'

describe Poloniex::Configuration do
  subject do
    Poloniex::Configuration.new
  end

  describe "#new" do
    it "sets default values" do
      assert_nil(subject.api_key)
      assert_nil(subject.api_secret)
      assert_nil(subject.debug)
      assert_nil(subject.logger)
    end
  end
end
