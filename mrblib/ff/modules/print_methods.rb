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
  # Methods to print out the requested connections or attributes.
  module PrintMethods
    include PrintCountMethods

    CONNECTION = 'CONNECTION'.freeze

    # Print the attribute value of the specified planets.
    #
    # @param [ Boolean ] with_count Print additional count column.
    #
    # @return [ Void ]
    def print_attributes(with_count = false)
      return print_attributes_with_count if with_count

      property        = @parser.attribute
      planets, values = planets_and_values { |p| [p.attributes[property]] }

      print_values(planets, [property], values)
    end

    # Print the connection string of the specified planets.
    #
    # @param [ Boolean ] with_count Print additional count column.
    #
    # @return [ Void ]
    def print_connections(with_count = false)
      return print_connections_with_count if with_count

      format          = @parser.format
      planets, values = planets_and_values { |p| [p.connection(format)] }

      print_values(planets, [CONNECTION], values)
    end

    private

    # Find all matching planets and their value by yielding the provided proc.
    #
    # @param [ Proc ] block A codeblock to map a planet to a value.
    #
    # @return [ Array<Planets[], String[]>]
    def planets_and_values(&block)
      planets = FF::Planet.find_all(@parser.matchers)
      values  = planets.map(&block)

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
      if @parser.print_pretty?
        puts FF::Table.new(planets, columns, values).to_s
      else
        planets.each_with_index { |p, i| puts msg(p.id, values[i].last) }
      end
    end
  end
end
