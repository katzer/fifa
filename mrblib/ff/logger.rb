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
  # Loggs all errors seperated by planet id
  class Logger
    # Initializes the logger.
    #
    # @param [ Symbol ] color Optional color to use for error messages.
    #
    # @return [ FF::Logger ]
    def initialize(color = :default)
      @color  = color
      @errors = {}
    end

    # Add an error message to the logger.
    #
    # @param [ Object ] key Usually the planet id.
    # @param [ String ] msg The error message.
    # @param [ Boolean ] replace Remove all previously logged messages.
    #
    # @return [ String ]
    def add(key, msg, replace = false)
      bucket = (@errors[key] ||= [])

      bucket.clear if replace

      if msg.is_a? String
        bucket << msg
        msg
      else
        bucket.concat(msg)
        msg.first
      end
    end

    # If the given key corresponds to error messages.
    #
    # @param [ Object ] key Usually the planet id.
    #
    # @return [ Boolean]
    def errors?(key = nil)
      key ? @errors.key?(key) : @errors.any?
    end

    # Logged error messages associated with the specified key.
    #
    # @param [ Object] key Usually the planet id.
    #
    # @return [ Array<String> ]
    def errors(key)
      errors?(key) ? @errors[key].uniq : []
    end

    # Return the joined error messages logged for the key or the provided
    # message if none errors are found.
    #
    # @param [ Object] key Usually the planet id.
    # @param [ String ] msg The none error message.
    # @param [ Boolean ] compact Join multiple message by whitespace.
    #                            Defaults to: false
    #
    # @return [ String ]
    def msg(key, msg = '', compact = false)
      values = errors?(key) ? colorize(key) : msg

      return values unless values.is_a? Array
      values.join(compact ? ', ' : "\n")
    end

    private

    # Colorized output for the error messages specified by the key.
    #
    # @param [ Object] key Usually the planet id.
    #
    # @return [ String ]
    def colorize(key)
      msgs = errors(key)
      msgs.map! { |e| e.set_color(@color) } if @color != :default
    end
  end
end
