module Cinch
  module Commands
    #
    # @api semipublic
    #
    class Command

      ARG_FORMATS = {
        string:  /\S+/,
        integer: /\d+/,
        float:   /\d*\.\d+/,
        text:    /.+/
      }

      attr_reader :name, :arguments, :summary, :description

      #
      # Creates a new command.
      #
      # @param [Symbol] name
      #   Name of the command.
      #
      # @param [Hash{Symbol => Symbol,Regexp,String,Array}] arguments
      #   Arguments names and their formats or possible values.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [String] :summary
      #
      # @option options [String] :description
      #
      def initialize(name,arguments,options={})
        @name        = name.to_s
        @arguments   = arguments
        @aliases     = options.fetch(:aliases,[]).map(&:to_s)

        @summary     = options[:summary]
        @description = options[:description]
      end

      #
      # Creates a Regular Expression that matches invocations of the command.
      #
      # @return [Regexp]
      #   A Regular Expression that matches the command and captures it's
      #   arguments.
      #
      def regexp
        pattern = '(?:' + Regexp.union([@name] + @aliases).source + ')'

        @arguments.each do |name,format|
          arg_regexp = case format
                       when Symbol
                         ARG_FORMATS.fetch(format)
                       when Regexp
                         format
                       else
                         Regexp.union(format)
                       end

          pattern << ' (' << arg_regexp.source << ')'
        end

        return Regexp.new(pattern)
      end

      #
      # The usage string for the command.
      #
      # @return [String]
      #   The usage string for the command and it's arguments.
      #
      def usage
        usage = "#{@name}"

        @arguments.each_key do |arg|
          usage << ' ' << arg.upcase
        end

        return usage
      end

    end
  end
end
