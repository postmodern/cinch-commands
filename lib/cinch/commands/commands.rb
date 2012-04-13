require 'cinch/commands/command'

module Cinch
  module Commands

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      #
      # All registered commands.
      #
      # @return [Array<Command>]
      #   The registered commands.
      #
      # @api semipublic
      #
      def commands
        @commands ||= []
      end

      protected

      #
      # Registers a command.
      #
      # @param [Symbol] name
      #
      # @param [Hash{Symbol => Symbol,Regexp}] arguments
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [String] :summary
      #   The short summary for the command.
      #
      # @option options [String] :description
      #   The long description for the command.
      #
      # @return [Command]
      #   The new command.
      #
      # @example
      #   command :grant, {name: :string, :level: :integer},
      #                   summary: "Grants access",
      #                   description: %{
      #                     Grants a certain level of access to the user
      #                   }
      #
      def command(name,arguments={},options={})
        new_command = Command.new(name,arguments,options)

        match(new_command.regexp, method: name)

        commands << new_command
        return new_command
      end
    end

  end
end
