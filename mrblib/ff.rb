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

def __main__(argv)
  parser = FF::OptParser.new(argv)

  if parser.print_usage?
    print_usage
  elsif parser.print_version?
    print_version
  elsif parser.print_attribute?
    print_attribute(parser.planet, parser)
  else
    print_connection(parser.planet, parser)
  end
end

def print_version
  puts "v#{FF::VERSION}"
end

def print_usage
  puts 'usage: ff [options...] <planet>'
  puts 'Options:'
  puts '-a=ATTRIBUTE    Show value of attribute'
  puts '-e=TYPE         Expected type of planet to validate against'
  puts '-f=FORMAT       Show formatted connection string'
  puts '                Possible formats are jdbc, sqlplus, url or tns'
  puts '-t, --type      Show type of planet'
  puts '-h, --help      This help text'
  puts '-v, --version   Show version number'
end

def print_attribute(planet_id, parser)
  planet   = FF::Planet.find(planet_id)
  attr_key = parser.attribute
  attr_val = planet.attributes[attr_key]

  validate_type(planet.type, parser)

  puts attr_val
end

def print_connection(planet_id, parser)
  planet     = FF::Planet.find(planet_id)
  connection = planet.connection(parser.format)

  validate_type(planet.type, parser)

  puts connection
end

def validate_type(type, parser)
  return if !parser.validate? || type == parser.expected_type
  raise "type missmatch: expected #{parser.expected_type} but got #{type}"
end
