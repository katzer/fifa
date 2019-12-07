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
  # Class reads the passed command-line arguments,
  # loads the date and presents the output.
  class Task < BasicObject
    # Initialize the task for given spec.
    #
    # @param [ Hash<Symbol,_>] spec The parsed command-line args.
    #
    # @return [ Void ]
    def initialize(spec)
      @spec = spec
      @spec.freeze
    end

    # Execute the task.
    #
    # @return [ Void ]
    def exec
      presenter.present
    end

    private

    # Rewrites the parsed command-line tail if grouping is requested.
    #
    # @return [ Array<String> ]
    def tail
      tail = @spec[:tail]

      return tail unless @spec[:group]

      key, val = tail[0, 2]

      Planet.planets
            .map { |p| p[key] }
            .uniq.compact
            .map! { |v| "#{key}=#{v}#{"@#{val}" if val}" }
    end

    # The parsed command-line matcher.
    #
    # @return [ Array<PlanetMatcher> ]
    def matchers
      tail.map { |m| PlanetMatcher.new(m) }
    end

    # The right presenter class based on the specs.
    #
    # @return [ Fifa::Presenter::BasePresenter ]
    def presenter
      if @spec[:type] || @spec[:attribute]
        Presenter::PropertyPresenter.new(@spec, matchers)
      else
        Presenter::ConnectionPresenter.new(@spec, matchers)
      end
    end
  end
end
