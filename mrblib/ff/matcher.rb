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
  # Identify planets by regular expressions
  class Matcher
    # Link of crumbs
    CRUMBS_PATTERN = /^[@%]?[^:=]*[:=]?[^@%]+(?:[@%]?[^:=]*[:=]?[^@%]+)*$/
    # Single crumb
    SPLIT_PATTERN  = /([@%][^@%]+)/
    # Single crumb
    CRUMB_PATTERN  = /^(@|%)?([^:=]*)(.)?(.*)$/

    # Initializes the matcher by specified crumbs.
    #
    # @param [ String ] matcher The matcher like 'env:prod'
    #
    # @return [ FF::Matcher ]
    def initialize(matcher)
      @string = matcher

      crumbs  = matcher.split(/\s+/)
      validate(crumbs)

      @crumbs = crumbs.map { |crumb| Crumbs.new(crumb) }
    end

    # Test if the crumbs matches the key:value map.
    #
    # @param [ Hash ] map A key:value hash map.
    #
    # @return [ Boolean ]
    def match?(map)
      @crumbs.all? { |crumb| crumb.match? map }
    end

    # The matcher's string representation.
    #
    # @return [ String ]
    def to_s
      @string.to_s
    end

    private

    # Raise an error if any of the crumbs are in wrong format.
    #
    # @param [ Array<String> ] crumbs The crumbs like ['env:prod']
    #
    # @return [ Void ]
    def validate(crumbs)
      crumbs.each do |crumb|
        raise "invalid matcher: #{crumb}" unless crumb =~ CRUMBS_PATTERN
      end
    end

    # Multiple crumbs combined by 'and'
    class Crumbs
      # Initializes all crumbs.
      #
      # @param [ String ] crumbs A crumb like 'env=prod+env=int'
      #
      # @return [ FF::Matcher::Crumbs ]
      def initialize(crumbs)
        @crumbs = crumbs.split(SPLIT_PATTERN)
                        .reject(&:empty?)
                        .map { |crumb| Crumb.new(crumb) }
      end

      # Test if the crumbs matches the key:value map.
      #
      # @param [ Hash ] map A key:value hash map.
      #
      # @return [ Boolean ]
      def match?(map)
        @crumbs.all? { |crumb| crumb.match? map }
      end

      # Single crumb
      class Crumb
        # Initializes a crumb.
        #
        # @param [ String ] crmb A crumb like '+env:prod'
        #
        # @return [ FF::Matcher::Crumb ]
        def initialize(crumb)
          match = crumb.match(CRUMB_PATTERN)
          value = match[3] ? match[4] : match[2]
          value = "^#{value}$" unless match[3] == ':'

          @not = match[1] == '%'
          @key = match[3] ? match[2] : 'id'
          @exp = Regexp.new(value)
        end

        # Test if the crumb matches.
        #
        # @param [ Hash ] map A key:value hash map.
        #
        # @return [ Boolean ]
        def match?(map)
          value = value_for_key(map)

          @not ? (value !~ @exp) : (value =~ @exp)
        end

        private

        # Get the string parsed value for the given key.
        #
        # @param [ Hash ] map Any key-value map.
        #
        # @return [ String ]
        def value_for_key(map)
          map[@key].to_s
        end
      end
    end
  end
end
