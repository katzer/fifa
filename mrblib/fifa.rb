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

Object.include FF::PrintMethods

def __main__(_)
  validate_options
  execute_request
  exit(1) if logger.errors?
end

# Raise an error if the tool was invoked with unknown options.
#
# @return [ Void ]
def validate_options
  return unless parser.unknown_opts?
  raise "unknown option: #{parser.unknown_opts.join ', '}"
end

# Execute the request.
#
# @return [ Void ]
def execute_request
  return print_usage      if parser.print_usage?
  return print_version    if parser.print_version?
  return print_attributes if parser.print_attribute?
  print_connections
end

# Print out the version number of the tool.
#
# @return [ Void ]
def print_version
  puts "v#{FF::VERSION} - #{OS.sysname} #{OS.bits(:binary)}-Bit (#{OS.machine})"
end

# codebeat:disable[LOC]

# Print out how to use these tool.
#
# @return [ Void ]
def print_usage
  puts <<-usage
usage: fifa [options...] <matcher>...
Options:
-a=ATTRIBUTE    Show value of attribute
-f=FORMAT       Show formatted connection string
                Possible formats are jdbc, sqlplus, url, tns or pqdb
--no-color      Print errors without colors
-p, --pretty    Pretty print output as a table
-t, --type      Show type of planet
-c, --count     Show count of matching planets
-h, --help      This help text
-v, --version   Show version number
usage
end

# codebeat:enable[LOC]

# Global opt parser.
#
# @return [ FF::OptParser ]
def parser
  @parser ||= FF::OptParser.new
end

# Global logger for error messages.
#
# @return [ FF::Logger ]
def logger
  $logger ||= FF::Logger.new(parser.no_color? ? :default : :red)
end

# See FF::ErrorLogger#add
#
def log(*args)
  logger.add(*args)
end

# See FF::ErrorLogger#msg
#
def msg(*args)
  logger.msg(*args)
end
