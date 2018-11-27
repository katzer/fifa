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
  module Presenter
    # Present the connection details of the planets.
    class ConnectionPresenter < BasePresenter
      # The columns to render.
      #
      # @return [ Array<String> ]
      def columns
        @spec[:count] ? %w[MATCHER CONNECTION COUNT] : ['CONNECTION']
      end

      # The format in which we have to present the connection details.
      #
      # @return [ String ]
      def format
        @spec[:format]
      end

      private

      # Print the connection string of the specified planets.
      #
      # @return [ Void ]
      def present_property
        __present__(*planets_and_values { |p| p.connection(format) })
      end

      # Print the connection string of the specified planets.
      #
      # @return [ Void ]
      def present_count
        __present__(*planets_and_counts { |p| p.connection(format) })
      end
    end
  end
end
