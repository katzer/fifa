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
  module Formatter
    # Formatter for database specific formats
    class Database < Base
      # Connection formatted to use for JDBC driver.
      # Raises an error if a required attribute is missing!
      #
      # @param [ FF::Planet ] planet The planet to format.
      #
      # @return [ String ]
      def jdbc(planet)
        log_if_missing(planet, 'host', 'port', 'sid')

        pre = 'jdbc:oracle:thin'
        suf = "#{planet['host']}:#{planet['port']}:#{planet['sid']}"

        if planet['password']
          "#{pre}:#{planet['user']}/#{planet['password']}@#{suf}"
        else
          "#{pre}:@#{suf}"
        end
      end

      # Connection formatted to use with SqlPlus
      # Raises an error if a required attribute is missing!
      #
      # @param [ FF::Planet ] planet The planet to format.
      #
      # @return [ String ]
      def sqlplus(planet)
        log_if_missing(planet, 'user')

        tns = tns(planet)

        if planet['password']
          "#{planet['user']}/#{planet['password']}@\"@#{tns}\""
        else
          "#{planet['user']}@\"@#{tns}\""
        end
      end

      # Connection formatted to use for TNS listener.
      # Raises an error if a required attribute is missing!
      #
      # @param [ FF::Planet ] planet The planet to format.
      #
      # @return [ String ]
      def tns(planet)
        log_if_missing(planet, 'host', 'port', 'sid')
        "(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=#{planet['host']})(PORT=#{planet['port']})))(CONNECT_DATA=(SID=#{planet['sid']})))" # rubocop:disable LineLength
      end

      # Connection formatted to use for qpdb.
      # Raises an error if a required attribute is missing!
      #
      # @param [ FF::Planet ] planet The planet to format.
      #
      # @return [ String ]
      def pqdb(planet)
        log_if_missing(planet, 'server', 'db')

        server = find_server(planet)
        value  = server.connection(:ssh)

        errors = logger.errors(server.id)
        log(planet.id, errors) if errors.any?

        "#{planet['db']}:#{value}"
      end

      private

      alias ski_value pqdb

      # The references planet
      #
      # @param [ FF::Planet ] planet The planet to format.
      #
      # @return [ FF::Planet ]
      def find_server(planet)
        if planet['server']
          FF::Planet.find(planet['server'])
        else
          FF::Planet.new('id' => planet.id, 'type' => FF::Planet::UNKNOWN)
        end
      end
    end
  end
end
