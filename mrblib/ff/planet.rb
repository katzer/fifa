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
  # Provides access to the content of the ORBIT_FILE.
  class Planet
    # Value for unknown property values
    UNKNOWN = 'unknown'.freeze

    # Find planet by ID. Raises an error if no planet could be found.
    #
    # @param [ String ] planet_id The Id of the planet.
    #
    # @return [ Planet ]
    def self.find(planet_id)
      planet = planets.find { |i| i['id'] == planet_id }

      unless planet
        planet = { 'id' => planet_id }
        log(planet_id, "unknown planet: #{planet_id}")
      end

      Planet.new(planet)
    end

    # Find planets by matchers.
    #
    # @param [ Array<FF::Matcher> ] matchers List of matchers.
    #
    # @return [ Array<Planet> ]
    def self.find_all(matchers)
      planets.select { |p| matchers.any? { |m| m.match? p } }
             .map { |p| Planet.new(p) }
             .sort!
    end

    # The parsed JSON file. Raises an error if the format is not JSON.
    #
    # @return [ Array<Hash> ]
    def self.planets
      @planets ||= OrbitFile.parse
    end

    # A planet is a single entry found in the ORBIT_FILE.
    #
    # @param [ Hash ] attributes Extracted attributes from the file.
    #
    # @return [ Planet ]
    def initialize(attributes)
      @attributes = attributes || {}
      @id         = @attributes['id']
    end

    # Property reader for the attributes.
    attr_reader :id, :attributes

    # The type of the planet.
    #
    # @return [ String ]
    def type
      @attributes['type'] || UNKNOWN
    end

    # The name of the planet.
    #
    # @return [ String ]
    def name
      @attributes['name'] || ''
    end

    # Compare with another planet.
    #
    # @param [ FF::Planet ] planet The other planet.
    #
    # @return [ Int ] -1, 0 or 1
    def <=>(other)
      [type, name, id] <=> [other.type, other.name, other.id]
    end

    # Formatted connection depend on the type (db, web or server).
    #
    # @param [ String ] format Possible values are url, tns, jdbc, ...
    #
    # @return [ String ]
    def connection(format)
      Formatter.for_type(type).format(format, attributes)
    end
  end
end
