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
      expect("#{command_name} #{args}").to match(subject)
    end

    it "should match the command-name aliases" do
      expect("#{command_alias} #{args}").to match(subject)
    end

    it "should capture the arguments" do
      match = "#{command_name} #{args}".match(subject)

      expect(match[1]).to eq(name_arg)
      expect(match[2]).to eq(level_arg)
      expect(match[3]).to eq(flag_arg)
    end

    it "should match the formats of the arguments" do
      expect("#{command_name} xxxxx xxxx xxxxx").not_to match(subject)
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
      expect(subject.start_with?(command_name)).to be(true)
    end

    it "should include the upper-case argument names" do
      expect(subject).to include("NAME LEVEL")
    end
  end
end
