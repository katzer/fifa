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

    # Instance of an base formatter.
    #
    # @return [ Formatter::Base ]
    def self.base_formatter
      @base ||= Base.new
    end
  end
end
