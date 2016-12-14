#
# Copyright (c) 2013-2016 by appPlant GmbH. All rights reserved.
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
    def self.find_all(planet_ids)
      planet_ids.map { |id| find(id) }
    end

    # The parsed JSON file. Raises an error if the format is not JSON.
    #
    # @return [ Array<Hash> ]
    def self.planets
      JSON.parse(IO.read(orbit_file_path))
    rescue RuntimeError
      raise "cannot read from #{orbit_file_path}"
    end

    # The file path where to find the ORBIT_FILE.
    # Raises an error if the env variable is not set.
    #
    # @return [ String ]
    def self.orbit_file_path
      ENV.fetch('ORBIT_FILE')
    rescue KeyError
      raise 'env ORBIT_FILE not set'
    end

    # A planet is a single entry found in the ORBIT_FILE.
    #
    # @param [ Hash ] attributes Extracted attributes from the file.
    #
    # @return [ Planet ]
    def initialize(attributes)
      @attributes = attributes
    end

    # Property reader for the attributes.
    attr_reader :attributes

    # The type of the planet.
    # Raises an error if the type is not set.
    #
    # @return [ String ]
    def type
      attributes['type'] || raise('unknown type')
    end

    # Formatted connection depend on the type (db, web or server).
    # Raises an error if the specified type is unknown.
    #
    # @param [ String ] format Possible values are url, tns or jdbc
    #                          Defaults to: default
    #
    # @return [ String ]
    def connection(format = nil)
      case type
      when 'web'
        web_connection
      when 'server'
        server_connection
      when 'db'
        db_connection(format)
      else
        raise "invalid type: #{type}"
      end
    end

    private

    # Connection formatted to use for CURL.
    # Raises an error if a required attribute is missing!
    #
    # @return [ String ]
    def web_connection
      raise_if_missing('url')
      attributes['url']
    end

    alias url_connection web_connection

    # Connection formatted to use for SSH.
    # Raises an error if a required attribute is missing!
    #
    # @return [ String ]
    def server_connection
      raise_if_missing('user', 'url')
      "#{attributes['user']}@#{attributes['url']}"
    end

    # Formatted connection for databases.
    # Raises an error if the specified format is unknown.
    #
    # @param [ String ] format Possible values are url, tns or jdbc
    #                          Defaults to: default
    #
    # @return [ String ]
    def db_connection(format = 'default')
      case format
      when 'default', 'url'
        url_connection
      when 'jdbc'
        jdbc_connection
      when 'tns'
        tns_connection
      when 'plus', 'sqlplus'
        sqlplus_connection
      when 'pqdb'
        pqdb_connection
      else
        raise "invalid format: #{format}"
      end
    end

    # Connection formatted to use for JDBC driver.
    # Raises an error if a required attribute is missing!
    #
    # @return [ String ]
    def jdbc_connection
      raise_if_missing('host', 'port', 'sid')

      pre = 'jdbc:oracle:thin'
      suf = "#{attributes['host']}:#{attributes['port']}:#{attributes['sid']}"

      if attributes['password']
        "#{pre}:#{attributes['user']}/#{attributes['password']}@#{suf}"
      else
        "#{pre}:@#{suf}"
      end
    end

    # Connection formatted to use with SqlPlus
    # Raises an error if a required attribute is missing!
    #
    # @return [ String ]
    def sqlplus_connection
      raise_if_missing('user')

      if attributes['password']
        "#{attributes['user']}/#{attributes['password']}@\"@#{tns_connection}\""
      else
        "#{attributes['user']}@\"@#{tns_connection}\""
      end
    end

    # Connection formatted to use for TNS listener.
    # Raises an error if a required attribute is missing!
    #
    # @return [ String ]
    def tns_connection
      raise_if_missing('host', 'port', 'sid')
      "(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=#{attributes['host']})(PORT=#{attributes['port']})))(CONNECT_DATA=(SID=#{attributes['sid']})))" # rubocop:disable LineLength
    end

    # Connection formatted to use for qpdb.
    # Raises an error if a required attribute is missing!
    #
    # @return [ String ]
    def pqdb_connection
      raise_if_missing('server', 'db')

      planet = self.class.find(attributes['server'])

      "#{attributes['db']}:#{planet.server_connection}"
    end

    # Raises an error if a provided attribute is missing.
    #
    # @param [ Array<String> ] keys The names of the attributes to check for.
    #
    # @return [ Void ]
    def raise_if_missing(*keys)
      keys.each { |attr| raise "unknown #{attr}" unless attributes[attr] }
    end
  end
end
