require 'spec_helper'
require 'cinch/commands/command'

describe Cinch::Commands::Command do
  let(:command_name) { 'foo' }
  let(:arguments)    { {name: :string, level: :integer, flag: %w[a o v]} }

  let(:summary)     { 'Foo command' }
  let(:description) { 'This is the foo command' }

  describe "#regexp" do
    let(:command_alias) { :fu }

    let(:command) do
      described_class.new(
        command_name, arguments,
        summary:     summary,
        description: description,
        aliases:     [command_alias]
      )
    end

    let(:name_arg)  { 'bob' }
    let(:level_arg) { '20'  }
    let(:flag_arg)  { 'o'  }
    let(:args)      { "#{name_arg} #{level_arg} #{flag_arg}" }

    subject { command.regexp }

    it { should be_kind_of(Regexp) }

    it "should match the primary command-name" do
      "#{command_name} #{args}".should =~ subject
    end

    it "should match the command-name aliases" do
      "#{command_alias} #{args}".should =~ subject
    end

    it "should capture the arguments" do
      match = "#{command_name} #{args}".match(subject)

      match[1].should == name_arg
      match[2].should == level_arg
      match[3].should == flag_arg
    end

    it "should match the formats of the arguments" do
      "#{command_name} xxxxx xxxx xxxxx".should_not =~ subject
    end
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
