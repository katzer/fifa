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
  # Wrapper around the Terminal::Table
  class Table
    # Print values as a formatted table.
    #
    # @param [ String ] column The name of the value column.
    # @param [ Array<Planet> ] planets Ordered list of requested planets.
    # @param [ Array ] values The entries for the value column.
    #
    # @return [ Void ]
    def initialize(column, planets, values)
      @title   = ARGV.join(' ')
      @columns = ['NR.', 'TYPE', 'ID', 'NAME', column.upcase]
      @style   = { all_separators: true }
      @rows    = convert_to_rows(planets, values)
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
      rows = []

      planets.each_with_index do |p, i|
        rows << ["#{i}.", p.type, p.id, p.name, msg(p.id, values[i])]
      end

      rows
    end
  end
end
