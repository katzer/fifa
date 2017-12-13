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
