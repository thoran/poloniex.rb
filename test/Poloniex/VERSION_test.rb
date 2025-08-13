require_relative '../helper'

describe Poloniex::VERSION do

  subject do
    Poloniex::VERSION
  end

  it "has a version number string" do
    _(subject).must_be_kind_of(String)
  end

  it "has a version number in the right format" do
    _(subject).must_match(/^\d\.\d\.\d$/)
  end
end
