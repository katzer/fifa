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
  # Class reads the passed command-line arguments,
  # loads the date and presents the output.
  class Task
    # Initialize the task for given spec.
    #
    # @param [ Hash<Symbol,_>] spec The parsed command-line args.
    #
    # @return [ Void ]
    def initialize(spec)
      @spec = spec
      @spec.freeze
    end

    # Execute the task.
    #
    # @return [ Void ]
    def exec
      if print_counts?
        print_attrs? ? print_attrs_counts : print_connections_counts
      else
        print_attrs? ? print_attrs : print_connections
      end
    end

    private

    # Rewrites the parsed command-line tail if grouping is requested.
    #
    # @return [ Array<String> ]
    def tail
      tail = @spec[:tail]

      return tail unless @spec[:group]

      key, val = tail[0, 2]

      Planet.planets
            .group_by { |p| p[key] }
            .keys.compact
            .map! { |v| "#{key}=#{v}#{"@#{val}" if val}" }
    end

    # The parsed command-line matcher.
    #
    # @return [ Array<Fifa::Matcher> ]
    def matchers
      tail.map { |m| Matcher.new(m) }
    end

    # If the tool should print the count of the matching planets.
    #
    # @return [ Boolean ]
    def print_counts?
      @spec[:count]
    end

    # If the tool should print attributes instead of connections.
    #
    # @return [ Boolean ]
    def print_attrs?
      @spec[:type] || @spec[:attribute]
    end

    # Print the attribute value of the specified planets.
    #
    # @return [ Void ]
    def print_attrs
      property        = @spec[:attribute] || 'type'
      planets, values = planets_and_values { |p| p[property] }

      print_values(planets, [property], values)
    end

    # Print the connection string of the specified planets.
    #
    # @return [ Void ]
    def print_attrs_counts
      property        = @spec[:attribute] || 'type'
      planets, values = planets_and_counts { |p| p[property] }

      print_values(planets, ['MATCHER', property, 'COUNT'], values)
    end

    # Print the connection string of the specified planets.
    #
    # @return [ Void ]
    def print_connections
      format          = @spec[:format]
      planets, values = planets_and_values { |p| p.connection(format) }

      print_values(planets, ['CONNECTION'], values)
    end

    # Print the connection string of the specified planets.
    #
    # @return [ Void ]
    def print_connections_counts
      format          = @spec[:format]
      planets, values = planets_and_counts { |p| p.connection(format) }

      print_values(planets, %w[MATCHER CONNECTION COUNT], values)
    end

    # Find all matching planets and their value by yielding the provided proc.
    #
    # @param [ Proc ] block A codeblock to map a planet to a value.
    #
    # @return [ Array<Planets[], String[]>]
    def planets_and_values
      planets = Planet.find_all(matchers)
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

      matchers.each do |matcher|
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

    # Print values to stdout.
    #
    # @param [ Array<Planet> ] planets List of planets.
    # @param [ Array<String> ] columns List of additional column names.
    # @param [ Array<String> ] values  Values for each additional column.
    #
    # @return [ Void ]
    def print_values(planets, columns, values)
      if @spec[:pretty]
        puts Table.new(@spec, columns).render(planets, values)
      else
        planets.each { |p| puts Logger.msg(p.id, values.shift.last, true) }
      end
    end
  end
end
