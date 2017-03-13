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
    #
    # @return [ String ] The passed msg
    def add(key, msg)
      (@errors[key] ||= []) << "<#{msg}>"
      msg
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
      errors?(key) ? colorize(key, compact) : msg
    end

    private

    # Colorized output for the error messages specified by the key.
    #
    # @param [ Object] key Usually the planet id.
    # @param [ Boolean ] compact Join multiple message by whitespace.
    #
    # @return [ String ]
    def colorize(key, compact)
      msgs = errors(key)
      msgs.map! { |e| e.set_color(@color) } if @color != :default
      msgs.join(compact ? ', ' : "\n")
    end
  end
end
