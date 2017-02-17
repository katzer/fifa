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

def __main__(_)
  @parser = FF::OptParser.new
  validate_options
  execute_request
  exit(1) if logger.errors?
end

# Raise an error if the tool was invoked with unknown options.
#
# @return [ Void ]
def validate_options
  return unless @parser.unknown_opts?
  raise "unknown option: #{@parser.unknown_opts.join ', '}"
end

# Execute the request.
#
# @return [ Void ]
def execute_request
  if @parser.print_usage?
    print_usage
  elsif @parser.print_version?
    print_version
  elsif @parser.print_attribute?
    print_attributes(@parser.planets)
  else
    print_connections(@parser.planets)
  end
end

# Print out the version number of the tool.
#
# @return [ Void ]
def print_version
  puts "v#{FF::VERSION} - #{OS.sysname} #{OS.bits(:binary)}-Bit (#{OS.machine})"
end

# Print out how to use these tool.
#
# @return [ Void ]
def print_usage
  puts <<-usage
usage: fifa [options...] <planet>...
Options:
-a=ATTRIBUTE    Show value of attribute
-e=TYPE         Expected type of planet to validate against
-f=FORMAT       Show formatted connection string
                Possible formats are jdbc, sqlplus, url, tns or pqdb
-p, --pretty    Pretty print output as a table
-t, --type      Show type of planet
-h, --help      This help text
-v, --version   Show version number
usage
end

# Print the attribute value of the specified planets.
#
# @param [ String ] planet_ids The ids of the planets.
#
# @return [ Void ]
def print_attributes(planet_ids)
  planets   = FF::Planet.find_all(planet_ids)
  attribute = @parser.attribute
  values    = planets.map { |planet| planet.attributes[attribute] }

  planets.each { |planet| validate_type(planet) }
  print_values(attribute, planets, values)
end

# Print the connection string of the specified planets.
#
# @param [ String ] planet_ids The ids of the planets.
#
# @return [ Void ]
def print_connections(planet_ids)
  planets     = FF::Planet.find_all(planet_ids)
  connections = planets.map { |planet| planet.connection(@parser.format) }

  planets.each { |planet| validate_type(planet) }
  print_values('CONNECTION', planets, connections)
end

# Print values to stdout.
#
# @param [ String ] column See `print_as_table`.
# @param [ Array<Planet> ] planets See `print_as_table`.
# @param [ Array ] values See `print_as_table`.
#
# @return [ Void ]
def print_values(column, planets, values)
  if @parser.print_pretty?
    puts FF::Table.new(column, planets, values).to_s
  else
    planets.each_with_index { |p, i| puts msg(p.id, values[i]) }
  end
end

# Raises an error if the type does not match the expected type.
#
# @param [ FF::Planet ] planet The planet to validate against
#
# @return [ Void ]
def validate_type(planet)
  expected_type = @parser.expected_type
  type          = planet.type

  return if !@parser.validate? || planet.unknown? || type == expected_type

  log(planet.id, 'type missmatch')
end

# Global logger for error messages.
#
# @return [ FF::Logger ]
def logger
  $logger ||= FF::Logger.new
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
