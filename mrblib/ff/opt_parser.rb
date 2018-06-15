# Apache 2.0 License
#
# Copyright (c) 2016 Sebastian Katzer, appPlant GmbH
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

module FF
  # Class for command-line option analysis.
  class OptParser
    # List of all supported options
    OPTIONS = [
      '-g', '--group',
      '-c', '--count',
      '-v', '--version',
      '-h', '--help',
      '-t', '--type',
      '-p', '--pretty',
      '-s', '--sort',
      '--no-color',
      '-a=',
      '-f='
    ].freeze

    # Initialize the parser and check for unknown options
    #
    # @param [ Array<String> ] args List of command-line arguments.
    #
    # @return [ FF::OptParser ]
    def initialize(args = ARGV[1..-1])
      @args = args || []
    end

    # List all unknown options.
    #
    # @return [ Array<String> ]
    def unknown_opts
      @args.select { |opt| opt[0] == '-' }
           .map { |opt| opt.include?('=') ? opt[0..2] : opt }
           .reject { |opt| OPTIONS.include? opt }
    end

    # If the parser contains unknown options.
    #
    # @return [ Boolean ]
    def unknown_opts?
      unknown_opts.any?
    end

    # If the tool should print out the version number.
    #
    # @return [ Boolean ] Yes if the options include -v or --version.
    def print_version?
      flag_given? 'version'
    end

    # If the tool should print out the usage.
    #
    # @return [ Boolean ] Yes if the options include -h or --help.
    def print_usage?
      flag_given? 'help'
    end

    # If the tool should print out attributes other then the connection.
    #
    # @return [ Boolean ] Yes if the options include -t, --type or -a.
    def print_attribute?
      @args.any? { |opt| opt == '-t' || opt == '--type' || opt[0..2] == '-a=' }
    end

    # If the tool should print out everything in a formatted table.
    #
    # @return [ Boolean ] Yes if the options include -p, --pretty.
    def print_pretty?
      flag_given? 'pretty'
    end

    # If the tool should print out the count of matching planets.
    #
    # @return [ Boolean ] Yes if the options include -c, --count.
    def print_count?
      flag_given? 'count'
    end

    # If the tool should print out the planets in sorted order.
    #
    # @return [ Boolean ] Yes if the options include -s, --sort.
    def print_sorted?
      flag_given? 's'
    end

    # If the tool should group all planets by attribute value.
    #
    # @return [ Boolean ] Yes if the options include --group.
    def group_by?
      flag_given? 'group'
    end

    # If the tool should print out errors without color.
    #
    # @return [ Boolean ] Yes if the options include --no-color.
    def no_color?
      flag_given? '--no-color'
    end

    # The attribute to find for.
    #
    # @return [ String ] Ddefaults to: type.
    def attribute
      param_value('-a', 'type')
    end

    # The format of the connection string.
    #
    # @return [ String ] Ddefaults to: default.
    def format
      param_value('-f', 'default')
    end

    # The passed planet ids.
    #
    # @return [ Array<FF::Matcher> ]
    def matchers
      list = tail.map { |m| FF::Matcher.new(m) }
      list.empty? ? [FF::Matcher.new('id:.')] : list
    end

    private

    # If the specified flag is given in args list.
    #
    # @param [ String ] name The (long) flag name.
    def flag_given?(flag)
      if flag.start_with? '-'
        @args.include?(flag)
      else
        @args.include?("-#{flag[0]}") || @args.include?("--#{flag}")
      end
    end

    # The tail of the command arguments.
    #
    # @return [ Array<String> ]
    def tail
      tail = @args.reject { |opt| opt[0] == '-' }

      return tail unless group_by?

      list = {}
      attr = tail[0]

      Planet.planets.each { |p| list[p[attr]] = 0 unless p[attr].to_s.empty? }

      list.keys.map { |v| "#{attr}=#{v}#{"@#{tail[1]}" if tail[1]}" }
    end

    # Extract the value of the specified options.
    # Raises an error if the option has been specified but without an value.
    #
    # @param [ String ] attr The options to look for.
    # @param [ Object ] default_value The default value to use for
    #                                 if the options has not been specified.
    #
    # @return [ Object ]
    def param_value(attr, default_value = nil)
      arg = @args.find { |opt| opt[0..2] == "#{attr}=" }
      arg ? arg.sub("#{attr}=", '') : default_value
    rescue NoMethodError
      raise "Missing value for flag #{attr}"
    end
  end
end
