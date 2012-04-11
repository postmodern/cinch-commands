require 'spec_helper'
require 'cinch/commands'

describe Cinch::Commands do
  it "should have a VERSION constant" do
    subject.const_get('VERSION').should_not be_empty
  end
end
