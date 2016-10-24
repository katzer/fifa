#
# Copyright (c) 2013-2016 by appPlant GmbH. All rights reserved.
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
  class OptParser
    def initialize(args = ARGV)
      @args = args || []
    end

    def print_version?
      @args.include?('-v') || @args.include?('--version')
    end

    def print_usage?
      @args.include?('-h') || @args.include?('--help') || @args.size < 2
    end

    def print_type?
      @args.include?('-t') || @args.include?('--type')
    end

    def validate?
      @args.any? { |opt| opt[0..2] == '-e=' }
    end

    def expected_type
      @args.find { |opt| opt[0..2] == '-e=' }
           .sub('-e=', '')
    rescue NoMethodError
      nil
    end

    def format
      @args.find { |opt| opt[0..2] == '-f=' }
           .sub('-f=', '')
    rescue NoMethodError
      'default'
    end

    def planet
      @args.last if @args.size > 1
    end
  end
end
