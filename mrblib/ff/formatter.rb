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
  # Public interface to interact with the Formatter classes.
  module Formatter
    # Find right formatter for planet by type.
    #
    # @param [ String ] type The type of the formatter.
    #
    # @return [ FF::Formatter::Base ]
    def self.for_type(type)
      case type
      when 'server'
        server_formatter
      when 'web'
        web_formatter
      when 'db', 'database'
        database_formatter
      else
        base_formatter
      end
    end

    # Instance of formatter for planets of type server.
    #
    # @return [ Formatter::Server ]
    def self.server_formatter
      @server ||= Server.new
    end

    # Instance of formatter for planets of type db.
    #
    # @return [ Formatter::Database ]
    def self.database_formatter
      @db ||= Database.new
    end

    # Instance of formatter for planets of type web.
    #
    # @return [ Formatter::Web ]
    def self.web_formatter
      @web ||= Web.new
    end

    # Instance of an basic formatter.
    #
    # @return [ Formatter::Web ]
    def self.base_formatter
      @base ||= Base.new
    end
  end
end
