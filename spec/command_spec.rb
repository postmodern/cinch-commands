require 'spec_helper'
require 'cinch/commands/command'

describe Cinch::Commands::Command do
  let(:command_name) { 'foo' }
  let(:arguments)    { {name: :string, level: :integer} }

  let(:summary)     { 'Foo command' }
  let(:description) { 'This is the foo command' }

  describe "#format" do
  end

  describe "#usage" do
    let(:command) do
      described_class.new(
        command_name, arguments,
        summary:     summary,
        description: description
                          
      )
    end

    subject { command.usage }

    it "should include the command name" do
      subject.start_with?(command_name).should be_true
    end

    it "should include the upper-case argument names" do
      subject.should include("NAME LEVEL")
    end
  end
end
