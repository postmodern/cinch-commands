require 'cinch/commands/commands'

require 'cinch/plugin'

module Cinch
  module Commands
    class Help

      include Cinch::Plugin
      include Cinch::Commands

      command :help, {command: :string},
              summary:     %{Displays help information for the COMMAND},
              description: %{
                Finds the COMMAND and prints the usage and description for the
                COMMAND.
              }

      def help(m,command=nil)
        if command
          found = commands_named(command)

          if found.empty?
            m.reply "help: Unknown command #{command.dump}"
          else
            # print all usages
            found.each { |cmd| m.reply cmd.usage }

            # print the description of the first command
            m.reply ''
            m.reply found.first.description
          end
        else
          each_command do |cmd|
            m.reply "#{cmd.usage} - #{cmd.summary}"
          end
        end
      end

      protected

      def each_command(&block)
        return enum_for(__method__) unless block_given?

        bot.config.plugins.plugins.each do |plugin|
          if plugin < Cinch::Commands
            plugin.commands.each(&block)
          end
        end
      end

      def command_named(name)
        each_command.select { |command| command.name == name }
      end

    end
  end
end
