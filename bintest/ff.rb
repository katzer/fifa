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

require 'open3'
require_relative '../mrblib/ff/version'

def orbit_env_get(file = nil)
  if file
    { 'ORBIT_FILE' => File.expand_path("config/#{file}.json", __dir__) }
  else
    { 'ORBIT_HOME' => __dir__ }
  end
end

BINARY    = File.expand_path('../mruby/bin/ff', __dir__)

ORBIT_ENV = orbit_env_get.freeze
PASWD_ENV = orbit_env_get('orbit_file.password').freeze
INCMP_ENV = orbit_env_get('orbit_file.incomplete').freeze
WRONG_ENV = orbit_env_get('wrong').freeze

assert('version [-v]') do
  output, status = Open3.capture2(BINARY, '-v')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, FF::VERSION
end

assert('version [--version]') do
  output, status = Open3.capture2(BINARY, '--version')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, FF::VERSION
end

assert('usage [-h]') do
  output, status = Open3.capture2(BINARY, '-h')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, 'usage'
end

assert('usage [--help]') do
  output, status = Open3.capture2(BINARY, '--help')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, 'usage'
end

assert('unknown planet') do
  _, output, status = Open3.capture3(ORBIT_ENV, BINARY, '<unknown>')

  assert_false status.success?, 'Process did exit cleanly'
  assert_include output, 'unknown planet'
end

assert('server') do
  output, status = Open3.capture2(ORBIT_ENV, BINARY, 'my-app')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, 'user1@url1.de'
end

assert('web') do
  output, status = Open3.capture2(ORBIT_ENV, BINARY, 'my-web')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, 'https://url.1.net'
end

assert('db') do
  output, status = Open3.capture2(ORBIT_ENV, BINARY, 'my-db')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, 'url_url1.bla.blergh.de'
end

assert('all connections') do
  output, status = Open3.capture2(ORBIT_ENV, BINARY)

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, 'user1@url1.de'
  assert_include output, 'url_url1.bla.blergh.de'
  assert_include output, 'https://url.1.net'
end

assert('multi connections') do
  output, status = Open3.capture2(ORBIT_ENV, BINARY, 'my-db', 'my-web')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, 'url_url1.bla.blergh.de'
  assert_include output, 'https://url.1.net'
end

assert('all types') do
  output, status = Open3.capture2(ORBIT_ENV, BINARY, '-t')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, 'server'
  assert_include output, 'db'
  assert_include output, 'web'
end

assert('multi types') do
  output, status = Open3.capture2(ORBIT_ENV, BINARY, '-t', 'my-db', 'my-web')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, 'db'
  assert_include output, 'web'
end

assert('jdbc format') do
  output, status = Open3.capture2(ORBIT_ENV, BINARY, '-f=jdbc', 'my-db')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, 'host1.bla:666:horst1'
end

assert('jdbc format with password') do
  output, status = Open3.capture2(PASWD_ENV, BINARY, '-f=jdbc', 'my-db')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, 'user1/uwish@host1.bla:666:horst1'
end

assert('tns format') do
  output, status = Open3.capture2(ORBIT_ENV, BINARY, '-f=tns', 'my-db')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, '(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=host1.bla)(PORT=666)))(CONNECT_DATA=(SID=horst1)))' # rubocop:disable LineLength
end

assert('sqlplus format') do
  output, status = Open3.capture2(ORBIT_ENV, BINARY, '-f=plus', 'my-db')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, 'user1@"@(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=host1.bla)(PORT=666)))(CONNECT_DATA=(SID=horst1)))"' # rubocop:disable LineLength
end

assert('sqlplus format with password') do
  output, status = Open3.capture2(PASWD_ENV, BINARY, '-f=plus', 'my-db')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, 'user1/uwish@"@(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=host1.bla)(PORT=666)))(CONNECT_DATA=(SID=horst1)))"' # rubocop:disable LineLength
end

assert('pqdb format') do
  output, status = Open3.capture2(ORBIT_ENV, BINARY, '-f=pqdb', 'my-db')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, 'OP_DB:user1@url1.de'
end

assert('pretty type') do
  output, status = Open3.capture2(ORBIT_ENV, BINARY, '-t', '-p', 'my-app')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, 'TYPE'
  assert_include output, 'server'
end

assert('pretty connection') do
  output, status = Open3.capture2(ORBIT_ENV, BINARY, '-p', 'my-app')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, 'CONNECTION'
  assert_include output, 'user1@url1.de'
end

assert('attribute match') do
  output, status = Open3.capture2(ORBIT_ENV, BINARY, '-a=port', 'my-db')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, '666'
end

assert('type match') do
  _, status = Open3.capture2(ORBIT_ENV, BINARY, '-e=db', 'my-db')

  assert_true status.success?, 'Process did not exit cleanly'
end

assert('type missmatch') do
  _, output, status = Open3.capture3(ORBIT_ENV, BINARY, '-e=db', 'my-app')

  assert_false status.success?, 'Process did exit cleanly'
  assert_include output, 'type missmatch'
end

assert('incomplete server') do
  _, output, status = Open3.capture3(INCMP_ENV, BINARY, 'my-app')

  assert_false status.success?, 'Process did exit cleanly'
  assert_include output, 'unknown'
end

assert('incomplete db') do
  _, output, status = Open3.capture3(INCMP_ENV, BINARY, 'my-db')

  assert_false status.success?, 'Process did exit cleanly'
  assert_include output, 'unknown'
end

assert('incomplete web') do
  _, output, status = Open3.capture3(INCMP_ENV, BINARY, 'my-web')

  assert_false status.success?, 'Process did exit cleanly'
  assert_include output, 'unknown'
end

assert('ORBIT_FILE: not set') do
  _, output, status = Open3.capture3(BINARY, 'planet')

  assert_false status.success?, 'Process did exit cleanly'
  assert_include output, 'not set'
end

assert('ORBIT_FILE: wrong path') do
  _, output, status = Open3.capture3(WRONG_ENV, BINARY, 'planet')

  assert_false status.success?, 'Process did exit cleanly'
  assert_include output, 'cannot read'
end
