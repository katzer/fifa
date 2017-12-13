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
  # Methods to print out the requested connections or attributes.
  module PrintMethods
    include PrintCountMethods

    CONNECTION = 'CONNECTION'.freeze

    # Print the attribute value of the specified planets.
    #
    # @return [ Void ]
    def print_attributes
      return print_attributes_with_count if parser.print_count?

      property        = parser.attribute
      planets, values = planets_and_values { |p| p[property] }

      print_values(planets, [property], values)
    end

    # Print the connection string of the specified planets.
    #
    # @return [ Void ]
    def print_connections
      return print_connections_with_count if parser.print_count?

      format          = parser.format
      planets, values = planets_and_values { |p| p.connection(format) }

      print_values(planets, [CONNECTION], values)
    end

    private

    # Find all matching planets and their value by yielding the provided proc.
    #
    # @param [ Proc ] block A codeblock to map a planet to a value.
    #
    # @return [ Array<Planets[], String[]>]
    def planets_and_values
      planets = FF::Planet.find_all(parser.matchers)
      values  = planets.map { |p| [yield(p)] }

      [planets, values]
    end

    # Print values to stdout.
    #
    # @param [ Array<Planet> ] planets List of planets.
    # @param [ Array<String> ] columns List of additional column names.
    # @param [ Array<String> ] values Values for each additional column.
    #
    # @return [ Void ]
    def print_values(planets, columns, values)
      if parser.print_pretty?
        puts FF::Table.new(planets, columns, values).to_s
      else
        planets.each_with_index { |p, i| puts msg(p.id, values[i].last, true) }
      end
    end
  end
end
