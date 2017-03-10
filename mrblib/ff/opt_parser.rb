#
# Copyright (c) 2016 by appPlant GmbH. All rights reserved.
#
# @APPPLANT_LICENSE_HEADER_START@
#
# This file contains Original Code and/or Modifications of Original Code
# as defined in and that are subject to the Apache License
# Version 2.0 (the 'License'). You may not use this file except in
# compliance with the License. Please obtain a copy of the License at
# http://opensource.org/licenses/Apache-2.0/ and read it before using this
# file.
#
# The Original Code and all software distributed under the License are
# distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
# EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
# INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT.
# Please see the License for the specific language governing rights and
# limitations under the License.
#
# @APPPLANT_LICENSE_HEADER_END@

# rubocop:disable MutableConstant

module FF
  # Class for command-line option analysis.
  class OptParser
    # List of all supported options
    OPTIONS = [
      '-c', '--count',
      '-v', '--version',
      '-h', '--help',
      '-t', '--type',
      '-p', '--pretty',
      '-a=',
      '-f='
    ]

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

    # If the specified flag is given in args list.
    #
    # @param [ String ] name The (long) flag name.
    def flag_given?(flag)
      @args.include?("-#{flag[0]}") || @args.include?("--#{flag}")
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
      list = @args.select { |opt| opt[0] != '-' }
                  .map { |m| FF::Matcher.new(m) }

      list.empty? ? list << FF::Matcher.new('id:.') : list
    end

    private

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
