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
  # Wrapper around the Terminal::Table
  class Table
    # Print values as a formatted table.
    #
    # @param [ Array<Planet> ] planets List of planets.
    # @param [ Array<String> ] columns List of additional column names.
    # @param [ Array<String> ] values Values for each additional column.
    #
    # @return [ Void ]
    def initialize(planets, columns, values)
      @title   = ARGV.join(' ').sub(/^(.*?)(?=fifa)/, '')
      @columns = ['NR.', 'ID', 'TYPE', 'NAME']
      @style   = { all_separators: true }
      @rows    = convert_to_rows(planets, values)

      columns.each { |col| @columns << col.upcase }
    end

    # Pretty formatted terminal table string.
    #
    # @return [ String ]
    def to_s
      table.to_s
    end

    private

    # Internal table object.
    #
    # @return [ Terminal::Table ]
    def table
      Terminal::Table.new do |t|
        t.headings = @columns
        t.style    = @style
        t.rows     = @rows
        t.title    = @title
        t.align_column 0, :right
      end
    end

    # Converts the planets and values into table row structures.
    #
    # @param [ Array<Planet> ] planets Ordered list of requested planets.
    # @param [ Array ] values The entries for the value column.
    #
    # @return [ Array ]
    def convert_to_rows(planets, values)
      planets.zip(values).map do |p, cells|
        row       = ["#{planets.index(p)}.", p.id, colorize_type(p), p.name]
        cells[-1] = msg(p.id, cells.last)

        row.concat(cells)
      end
    end

    # The type of the planet, colorized with unknown.
    #
    # @param [ FF::Planet ] planet The planet to use for.
    #
    # @return [ String ]
    def colorize_type(p)
      p.unknown? && !parser.no_color? ? p.type.set_color(:red) : p.type
    end
  end
end
