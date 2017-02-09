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
      # @param [ Array<String> ] params List of attributes where to look for.
      #
      # @return [ String ]
      def jdbc(params)
        log_if_missing(params, 'host', 'port', 'sid')

        pre = 'jdbc:oracle:thin'
        suf = "#{params['host']}:#{params['port']}:#{params['sid']}"

        if params['password']
          "#{pre}:#{params['user']}/#{params['password']}@#{suf}"
        else
          "#{pre}:@#{suf}"
        end
      end

      # Connection formatted to use with SqlPlus
      # Raises an error if a required attribute is missing!
      #
      # @param [ Array<String> ] params List of attributes where to look for.
      #
      # @return [ String ]
      def sqlplus(params)
        log_if_missing(params, 'user')

        tns = tns(params)

        if params['password']
          "#{params['user']}/#{params['password']}@\"@#{tns}\""
        else
          "#{params['user']}@\"@#{tns}\""
        end
      end

      # Connection formatted to use for TNS listener.
      # Raises an error if a required attribute is missing!
      #
      # @param [ Array<String> ] params List of attributes where to look for.
      #
      # @return [ String ]
      def tns(params)
        log_if_missing(params, 'host', 'port', 'sid')
        "(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=#{params['host']})(PORT=#{params['port']})))(CONNECT_DATA=(SID=#{params['sid']})))" # rubocop:disable LineLength
      end

      # Connection formatted to use for qpdb.
      # Raises an error if a required attribute is missing!
      #
      # @param [ Array<String> ] params List of attributes where to look for.
      #
      # @return [ String ]
      def pqdb(params)
        log_if_missing(params, 'server', 'db')
        "#{params['db']}:#{FF::Planet.find(params['server']).connection(:ssh)}"
      end

      # Connection formatted to use for internals.
      # Raises an error if a required attribute is missing!
      #
      # @param [ Array<String> ] params List of attributes where to look for.
      #
      # @return [ String ]
      def ski(params)
        "db|#{params['id']}|#{params['name']}|#{pqdb(params)}"
      end
    end
  end
end
