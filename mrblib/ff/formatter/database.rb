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
