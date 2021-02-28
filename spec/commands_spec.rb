require 'spec_helper'
require 'cinch/commands'

describe Cinch::Commands do
  it "should have a VERSION constant" do
    expect(subject.const_get('VERSION')).not_to be_empty
  end
end
