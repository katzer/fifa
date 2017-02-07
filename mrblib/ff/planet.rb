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
    # Find planet by ID. Raises an error if no planet could be found.
    #
    # @param [ String ] planet_id The Id of the planet.
    #
    # @return [ Planet ]
    def self.find(planet_id)
      planet = planets.find { |i| i['id'] == planet_id }
      raise 'unknown planet' unless planet
      Planet.new(planet)
    end

    # Find planets by ID. Raises an error if a planet could not be found.
    #
    # @param [ Array<String> ] planet_ids An array of planet ids.
    #
    # @return [ Array<Planet> ]
    def self.find_with_ids(planet_ids)
      planet_ids.map { |id| find(id) }
    end

    # Find planets by ID. Returns all planets if no ids are specified.
    # Raises an error if a planet could not be found.
    #
    # @param [ Array<String> ] planet_ids Optional array of planet ids.
    #
    # @return [ Array<Planet> ]
    def self.find_all(planet_ids = nil)
      if planets.nil? || planet_ids.empty?
        planets.map { |planet| Planet.new(planet) }
      else
        find_with_ids(planet_ids)
      end
    end

    # The parsed JSON file. Raises an error if the format is not JSON.
    #
    # @return [ Array<Hash> ]
    def self.planets
      @planets ||= JSON.parse(IO.read(orbit_file_path))
    rescue RuntimeError
      raise "cannot read from #{orbit_file_path}"
    end

    # The file path where to find the ORBIT_FILE.
    # Raises an error if the env variable is not set.
    #
    # @return [ String ]
    def self.orbit_file_path
      if ENV.include? 'ORBIT_FILE'
        ENV['ORBIT_FILE']
      else
        File.join(ENV.fetch('ORBIT_HOME'), 'config/orbit_file.json')
      end
    rescue KeyError
      raise 'env ORBIT_HOME not set'
    end

    # A planet is a single entry found in the ORBIT_FILE.
    #
    # @param [ Hash ] attributes Extracted attributes from the file.
    #
    # @return [ Planet ]
    def initialize(attributes)
      @id         = attributes['id'].freeze
      @attributes = attributes
    end

    # Property reader for the attributes.
    attr_reader :id, :attributes

    # The type of the planet.
    # Raises an error if the type is not set.
    #
    # @return [ String ]
    def type
      attributes['type'] || raise('unknown type')
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
