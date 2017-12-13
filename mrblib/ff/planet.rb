# Apache 2.0 License
#
# Copyright (c) Copyright 2016 Sebastian Katzer, appPlant GmbH
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
  # Provides access to the content of the ORBIT_FILE.
  class Planet
    # Value for unknown property values
    UNKNOWN = 'missing'.freeze

    # Find planet by ID. Raises an error if no planet could be found.
    #
    # @param [ String ] planet_id The Id of the planet.
    #
    # @return [ Planet ]
    def self.find(planet_id)
      planet = planets.find { |i| i['id'] == planet_id }

      unless planet
        planet = { 'id' => planet_id, 'type' => UNKNOWN }
        log(planet_id, "unknown server: #{planet_id}")
      end

      Planet.new(planet)
    end

    # Find planets by matchers.
    #
    # @param [ Array<FF::Matcher> ] matchers List of matchers.
    #
    # @return [ Array<Planet> ]
    def self.find_all(matchers)
      items = planets.select { |p| matchers.any? { |m| m.match? p } }
                     .map! { |p| Planet.new(p) }

      items.sort! if parser.print_sorted?
      items
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
      @attributes = attributes
      @id         = @attributes['id']

      log(id, "#{UNKNOWN} type") unless attributes['type']
    end

    # Property reader for the attributes.
    attr_reader :id, :attributes

    # The type of the planet.
    #
    # @return [ String ]
    def type
      @type ||= @attributes['type'] || UNKNOWN
    end

    # The name of the planet.
    #
    # @return [ String ]
    def name
      @name ||= @attributes['name'] || ''
    end

    # The value for the given attribute.
    #
    # @param [ String ] The name of the attribute.
    #
    # @return [ Object ] The value of the attribute.
    def [](attr)
      @attributes[attr]
    end

    # If the type is unknown.
    #
    # @return [ Boolean ]
    def unknown?
      type == UNKNOWN
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
      Formatter.for_type(type).format(format, self)
    end
  end
end
