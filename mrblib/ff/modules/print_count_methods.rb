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
  # Methods to print out the requested connections or attributes with counts.
  module PrintCountMethods
    MATCHER = 'MATCHER'.freeze
    COUNT   = 'COUNT'.freeze

    # Print the connection string of the specified planets.
    #
    # @return [ Void ]
    def print_attributes_with_count
      property        = parser.attribute
      planets, values = planets_and_counts { |p| [p.attributes[property]] }

      print_values(planets, [MATCHER, property, COUNT], values)
    end

    # Print the connection string of the specified planets.
    #
    # @return [ Void ]
    def print_connections_with_count
      format          = parser.format
      planets, values = planets_and_counts { |p| [p.connection(format)] }

      print_values(planets, [MATCHER, CONNECTION, COUNT], values)
    end

    private

    # Find all matching planets and their value by yielding the provided proc.
    #
    # @param [ Proc ] block A codeblock to map a planet to a value.
    #
    # @return [ Array<Planets[], String[]>]
    def planets_and_counts(&block)
      planets  = []
      values   = []

      parser.matchers.each do |matcher|
        stars = FF::Planet.find_all([matcher])
        conns = stars.map(&block)

        values  << [matcher.to_s, conns.join("\n"), stars.size]
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
        'id' => planets.map(&:id).join("\n"),
        'type' => planets.map(&:type).join("\n"),
        'name' => planets.map(&:name).join("\n")
      )
    end
  end
end
