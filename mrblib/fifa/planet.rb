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
  # Provides access to the content of the ORBIT_FILE.
  class Planet < BasicObject
    # Value for unknown property values
    UNKNOWN = 'missing'.freeze

    # Find planet by ID. Raises an error if no planet could be found.
    #
    # @param [ String ] id The Id of the planet.
    #
    # @return [ Planet ]
    def self.find(id)
      planet = planets.find { |i| i['id'] == id }

      unless planet
        planet = { 'id' => id, 'type' => UNKNOWN }
        Logger.log(id, "unknown server: #{id}")
      end

      Planet.new(planet)
    end

    # Find planets by matchers.
    #
    # @param [ Array<PlanetMatcher> ] matchers List of matchers.
    #
    # @return [ Array<Planet> ]
    def self.find_all(matchers)
      planets.select { |p| matchers.any? { |m| m.match? p } }
             .map! { |p| Planet.new(p) }
    end

    # The parsed JSON file. Raises an error if the format is not JSON.
    #
    # @return [ Array<Hash> ]
    def self.planets
      @planets ||= OrbitFile.parse
    end

    # A planet is a single entry found in the ORBIT_FILE.
    #
    # @param [ Hash ] attrs Extracted attrs from the file.
    #
    # @return [ Planet ]
    def initialize(attrs)
      @attrs = attrs
      @id    = attrs['id']

      Logger.log(id, "#{UNKNOWN} type") unless attrs['type']
    end

    # The ID of the planet.
    #
    # @return [ String ]
    attr_reader :id

    # The type of the planet.
    #
    # @return [ String ]
    def type
      @type ||= @attrs['type'] || UNKNOWN
    end

    # The name of the planet.
    #
    # @return [ String ]
    def name
      @name ||= @attrs['name'] || ''
    end

    # The value for the given attribute.
    #
    # @param [ String ] The name of the attribute.
    #
    # @return [ Object ] The value of the attribute.
    def [](attr)
      @attrs[attr]
    end

    # If the type is unknown.
    #
    # @return [ Boolean ]
    def unknown?
      type == UNKNOWN
    end

    # Returns the planet's properties as a JSON string.
    #
    # @return [ String ]
    def to_json
      @attrs.to_json
    end

    # Compare with another planet.
    #
    # @param [ Fifa::Planet ] planet The other planet.
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
      Formatter.for_type(type).format(format, self)
    end
  end
end
