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
    # Base formatter for every planet type.
    class Base
      # Format the params by the given format.
      # Raises an error if a required attribute is missing
      # or the format is not supported!
      #
      # @param [ Symbol ] format The name of the format.
      # @param [ FF::Planet ] planet The planet to format.
      #
      # @return [ String ]
      def format(format, planet)
        send(format, planet)
      rescue NoMethodError
        log(planet.id, "unknown format: #{format}") unless planet.unknown?
      end

      # Connection formatted to use for CURL.
      # Raises an error if a required attribute is missing!
      #
      # @param [ FF::Planet ] planet The planet to format.
      #
      # @return [ String ]
      def url(planet)
        log_if_missing(planet, 'url')
        planet['url']
      end

      alias default url

      # Connection formatted to use for internals.
      # Raises an error if a required attribute is missing!
      #
      # @param [ FF::Planet ] planet The planet to format.
      #
      # @return [ String ]
      def ski(p)
        value  = msg(p.id, ski_value(p))
        bit    = logger.errors?(p.id) ? 0 : 1
        format = "#{bit}|#{p.id}|#{p.type}|#{p.name}|#{value}"

        log(p.id, format, !parser.print_pretty?) if bit != 1

        format
      end

      # Connection formatted as JSON.
      #
      # @param [ FF::Planet ] planet The planet to format.
      #
      # @return [ String ]
      def json(planet)
        planet.attributes.to_json
      end

      private

      # The content for the ski format.
      #
      # @param [ FF::Planet ] planet The planet to format.
      #
      # @return [ String ]
      def ski_value(planet)
        default(planet)
      end

      # Raises an error if a provided attribute is missing.
      #
      # @param [ FF::Planet ] planet The planet to format.
      # @param [ Array<String> ] keys The names of the params to check for.
      #
      # @return [ Void ]
      def log_if_missing(planet, *keys)
        keys.each { |k| log(planet['id'], "missing #{k}") unless planet[k] }
      end
    end
  end
end
