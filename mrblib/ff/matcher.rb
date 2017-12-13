# Apache 2.0 License
#
# Copyright (c) Copyright 2016 Sebastian Katzer, appPlant GmbH
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
