#
# Copyright (c) 2013-2016 by appPlant GmbH. All rights reserved.
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

  if @parser.print_usage?
    print_usage
  elsif @parser.print_version?
    print_version
  elsif @parser.print_attribute?
    print_attribute(@parser.planets)
  else
    print_connection(@parser.planets)
  end
end

# Print out the version number of the tool.
#
# @return [ Void ]
def print_version
  puts "v#{FF::VERSION}"
end

# Print out how to use these tool.
#
# @return [ Void ]
def print_usage
  puts 'usage: ff [options...] <planet>...'
  puts 'Options:'
  puts '-a=ATTRIBUTE    Show value of attribute'
  puts '-e=TYPE         Expected type of planet to validate against'
  puts '-f=FORMAT       Show formatted connection string'
  puts '                Possible formats are jdbc, sqlplus, url, tns or pqdb'
  puts '-p, --pretty    Pretty print output as a table'
  puts '-t, --type      Show type of planet'
  puts '-h, --help      This help text'
  puts '-v, --version   Show version number'
end

# Print the attribute value of the specified planet.
#
# @param [ String ] planet_ids The ids of the planets.
#
# @return [ Void ]
def print_attribute(planet_ids)
  planets   = FF::Planet.find_all(planet_ids)
  attribute = @parser.attribute
  values    = planets.map { |planet| planet.attributes[attribute] }

  planets.each { |planet| validate_type(planet.type) }
  print_values(attribute, planet_ids, values)
end

# Print the connection string of the specified planet.
#
# @param [ String ] planet_ids The ids of the planets.
#
# @return [ Void ]
def print_connection(planet_ids)
  planets     = FF::Planet.find_all(planet_ids)
  connections = planets.map { |planet| planet.connection(@parser.format) }

  planets.each { |planet| validate_type(planet.type) }
  print_values('CONNECTION', planet_ids, connections)
end

# Print values to stdout.
#
# @param [ String ] column See `print_as_table`.
# @param [ Array<String> ] planets See `print_as_table`.
# @param [ Array<values> ] values See `print_as_table`.
#
# @return [ Void ]
def print_values(column, planets, values)
  if @parser.print_pretty?
    print_as_table column, planets, values
  else
    values.each { |val| puts val }
  end
end

# Print values as a formatted table.
#
# print_as_table type, [app-package], [server]
#
#  NR  PLANET         TYPE
# ========================
#   0  app-package  server
#
# @param [ String ] column The name of the 3rd column.
# @param [ Array<String> ] planets The values for the 2nd column.
# @param [ Array<values> ] values The values for the 3rd column.
#
# @return [ Void ]
def print_as_table(column, planets, values)
  planet_length = (planets.map { |i| i.to_s.length } << 6).max
  value_length  = (values.map  { |i| i.to_s.length } << column.size).max
  row_format    = " %2s   %-#{planet_length}s   %-#{value_length}s"
  header        = format(row_format, 'NR', 'PLANET', column.upcase)

  puts header
  puts '=' * header.length

  values.each_with_index do |val, i|
    printf "#{row_format}\n", i, planets[i], val
  end
end

# Raises an error if the type does not match the expected type.
#
# @param [ String ] type The type to check.
#
# @return [ Void ]
def validate_type(type)
  return if !@parser.validate? || type == @parser.expected_type
  raise "type missmatch: expected #{@parser.expected_type} but got #{type}"
end
