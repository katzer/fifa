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

module Fifa
  module Presenter
    # Base presenter for all kind of outputs.
    class BasePresenter
      # Initialize the presenter for given spec.
      #
      # @param [ Hash<Symbol,_>]        spec     The parsed command-line args.
      # @param [ Array<Fifa::Matcher> ] matchers Defines the planets to present.
      #
      # @return [ Void ]
      def initialize(spec, matchers)
        @spec     = spec
        @matchers = matchers
      end

      # Print values to stdout.
      #
      # @return [ Void ]
      def present
        @spec[:count] ? present_count : present_property
      end

      private

      # Print values to stdout.
      #
      # @param [ Array<Planet> ] planets List of planets.
      # @param [ Array<String> ] values  Values for each additional column.
      #
      # @return [ Void ]
      def __present__(planets, values)
        if @spec[:pretty]
          puts Table.new(@spec, columns).render(planets, values)
        else
          planets.each { |p| puts Logger.msg(p.id, values.shift.last, true) }
        end
      end

      # Find all matching planets and their value by yielding the provided proc.
      #
      # @param [ Proc ] block A codeblock to map a planet to a value.
      #
      # @return [ Array<Planets[], String[]>]
      def planets_and_values
        planets = Planet.find_all(@matchers)
        planets.sort! if @spec[:sort]
        values = planets.map { |p| [yield(p)] }

        [planets, values]
      end

      # Find all matching planets and their value by yielding the provided proc.
      #
      # @param [ Proc ] block A codeblock to map a planet to a value.
      #
      # @return [ Array<Planets[], String[]>]
      def planets_and_counts
        planets, values = [], []

        @matchers.each do |matcher|
          stars = Planet.find_all([matcher])
          conns = stars.map { |p| [yield(p)] }.join("\n")

          values  << [matcher.to_s, conns, stars.size]
          planets << mash_planets(stars)
        end

        [planets, values]
      end

      # Mash list of planets into one planet by joining all values.
      #
      # @param [ Array<Fifa::Planet> ] planets List of planets.
      #
      # @return [ Fifa::Planet ]
      def mash_planets(planets)
        Planet.new(
          'id' => planets.map(&:id).join("\n"),
          'type' => planets.map(&:type).join("\n"),
          'name' => planets.map(&:name).join("\n")
        )
      end
    end
  end
end
