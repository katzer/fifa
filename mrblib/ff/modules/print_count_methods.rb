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
  # Methods to print out the requested connections or attributes with counts.
  module PrintCountMethods
    MATCHER = 'MATCHER'.freeze
    COUNT   = 'COUNT'.freeze
    LB      = "\n".freeze

    # Print the connection string of the specified planets.
    #
    # @return [ Void ]
    def print_attributes_with_count
      property        = parser.attribute
      planets, values = planets_and_counts { |p| p[property] }

      print_values(planets, [MATCHER, property, COUNT], values)
    end

    # Print the connection string of the specified planets.
    #
    # @return [ Void ]
    def print_connections_with_count
      format          = parser.format
      planets, values = planets_and_counts { |p| p.connection(format) }

      print_values(planets, [MATCHER, CONNECTION, COUNT], values)
    end

    private

    # Find all matching planets and their value by yielding the provided proc.
    #
    # @param [ Proc ] block A codeblock to map a planet to a value.
    #
    # @return [ Array<Planets[], String[]>]
    def planets_and_counts
      planets, values = [], []

      parser.matchers.each do |matcher|
        stars = FF::Planet.find_all([matcher])
        conns = stars.map { |p| [yield(p)] }.join(LB)

        values  << [matcher.to_s, conns, stars.size]
        planets << mash_planets(stars)
      end

      [planets, values]
    end

    # Mash list of planets into one planet by joining all values.
    #
    # @param [ Array<FF::Planet> ] planets List of planets.
    #
    # @return [ FF::Planet ]
    def mash_planets(planets)
      FF::Planet.new(
        'id' => planets.map(&:id).join(LB),
        'type' => planets.map(&:type).join(LB),
        'name' => planets.map(&:name).join(LB)
      )
    end
  end
end
