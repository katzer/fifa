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
  # Wrapper around the Terminal::Table
  class Table
    # Initialize a new table object.
    #
    # @param [ Hash ]   spec The parsed command line arguments.
    # @param [ String ] cols The name of the columns.
    #
    # @return [ Void ]
    def initialize(spec, cols)
      @spec = spec
      @cols = %w[NR. ID TYPE NAME].concat(cols.map!(&:upcase))
    end

    # Pretty formatted terminal table string.
    #
    # @param [ Array<Planet> ] planets Ordered list of requested planets.
    # @param [ Array ]         values  The entries for the value column.
    #
    # @return [ String ]
    def render(planets, values)
      table(planets, values).to_s
    end

    private

    # Internal table object.
    #
    # @param [ Array<Planet> ] planets Ordered list of requested planets.
    # @param [ Array ]         values  The entries for the value column.
    #
    # @return [ Terminal::Table ]
    def table(planets, values)
      ::Terminal::Table.new do |t|
        t.title    = ARGV.join(' ').sub(/^(.*?)(?=fifa)/, '')
        t.headings = @cols
        t.style    = { all_separators: true }
        t.rows     = rows(planets, values)
        t.align_column 0, :right
      end
    end

    # Converts the planets and values into table row structures.
    #
    # @param [ Array<Planet> ] planets Ordered list of requested planets.
    # @param [ Array ]         values  The entries for the value column.
    #
    # @return [ Array ]
    def rows(planets, values)
      planets.each_with_index do |p, idx|
        row          = ["#{idx}.", p.id, colorize_type(p), p.name]
        cells        = values.shift
        cells[-1]    = Logger.msg(p.id, cells.last)

        planets[idx] = row.concat(cells)
      end
    end

    # The type of the planet, colorized with unknown.
    #
    # @param [ Fifa::Planet ] planet The planet to use for.
    #
    # @return [ String ]
    def colorize_type(p)
      p.unknown? && !@spec[:'no-color'] ? p.type.set_color(:red) : p.type
    end
  end
end
