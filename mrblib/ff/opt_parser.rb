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

module FF
  # Class for command-line option analysis.
  class OptParser
    def initialize(args = ARGV[1..-1])
      @args = args || []
    end

    def print_version?
      @args.include?('-v') || @args.include?('--version')
    end

    def print_usage?
      @args.include?('-h') || @args.include?('--help') || @args.empty?
    end

    def print_attribute?
      @args.any? { |opt| opt == '-t' || opt == '--type' || opt[0..2] == '-a=' }
    end

    def print_pretty?
      @args.include?('-p') || @args.include?('--pretty')
    end

    def validate?
      @args.any? { |opt| opt[0..2] == '-e=' }
    end

    def attribute
      param_value('-a', 'type')
    end

    def expected_type
      param_value('-e')
    end

    def format
      param_value('-f', 'default')
    end

    def planets
      @args.select { |opt| opt[0] != '-' }
    end

    private

    def param_value(attr, default_value = nil)
      @args.find { |opt| opt[0..2] == "#{attr}=" }
           .sub("#{attr}=", '')
    rescue NoMethodError
      default_value
    end
  end
end
