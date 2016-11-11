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

require 'open3'
require_relative '../mrblib/ff/version'

def orbit_env_get(file)
  { 'ORBIT_FILE' => File.expand_path("fixtures/#{file}.json", __dir__) }
end

BINARY    = File.expand_path('../mruby/bin/ff', __dir__)

ORBIT_ENV = orbit_env_get('orbit_file').freeze
PASWD_ENV = orbit_env_get('orbit_file.password').freeze
INCMP_ENV = orbit_env_get('orbit_file.incomplete').freeze
WRONG_ENV = orbit_env_get('wrong').freeze

assert('version') do
  output, status = Open3.capture2(BINARY, '-v')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, FF::VERSION
end

assert('help') do
  output, status = Open3.capture2(BINARY, '-h')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, 'usage'
end

assert('missing planet') do
  output, status = Open3.capture2(BINARY)

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, 'usage'
end

assert('unknown planet') do
  _, output, status = Open3.capture3(ORBIT_ENV, BINARY, 'planet')

  assert_false status.success?, 'Process did exit cleanly'
  assert_include output, 'unknown planet'
end

assert('server') do
  output, status = Open3.capture2(ORBIT_ENV, BINARY, 'app-package')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, 'user1@url1.de'
end

assert('web') do
  output, status = Open3.capture2(ORBIT_ENV, BINARY, 'web-package')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, 'https://url.1.net'
end

assert('db') do
  output, status = Open3.capture2(ORBIT_ENV, BINARY, 'db-package')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, 'url_url1.bla.blergh.de'
end

assert('jdbc format') do
  output, status = Open3.capture2(ORBIT_ENV, BINARY, '-f=jdbc', 'db-package')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, 'host1.bla:666:horst1'
end

assert('jdbc format with password') do
  output, status = Open3.capture2(PASWD_ENV, BINARY, '-f=jdbc', 'db-package')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, 'user1/uwish@host1.bla:666:horst1'
end

assert('tns format') do
  output, status = Open3.capture2(ORBIT_ENV, BINARY, '-f=tns', 'db-package')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, '(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=host1.bla)(PORT=666)))(CONNECT_DATA=(SID=horst1)))' # rubocop:disable LineLength
end

assert('sqlplus format') do
  output, status = Open3.capture2(ORBIT_ENV, BINARY, '-f=plus', 'db-package')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, 'user1@"@(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=host1.bla)(PORT=666)))(CONNECT_DATA=(SID=horst1)))"' # rubocop:disable LineLength
end

assert('sqlplus format with password') do
  output, status = Open3.capture2(PASWD_ENV, BINARY, '-f=plus', 'db-package')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, 'user1/uwish@"@(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=host1.bla)(PORT=666)))(CONNECT_DATA=(SID=horst1)))"' # rubocop:disable LineLength
end

assert('attribute match') do
  output, status = Open3.capture2(ORBIT_ENV, BINARY, '-a=port', 'db-package')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, '666'
end

assert('type match') do
  _, status = Open3.capture2(ORBIT_ENV, BINARY, '-e=db', 'db-package')

  assert_true status.success?, 'Process did not exit cleanly'
end

assert('type missmatch') do
  _, output, status = Open3.capture3(ORBIT_ENV, BINARY, '-e=db', 'app-package')

  assert_false status.success?, 'Process did exit cleanly'
  assert_include output, 'type missmatch'
end

assert('incomplete server') do
  _, output, status = Open3.capture3(INCMP_ENV, BINARY, 'app-package')

  assert_false status.success?, 'Process did exit cleanly'
  assert_include output, 'unknown'
end

assert('incomplete db') do
  _, output, status = Open3.capture3(INCMP_ENV, BINARY, 'db-package')

  assert_false status.success?, 'Process did exit cleanly'
  assert_include output, 'unknown'
end

assert('incomplete web') do
  _, output, status = Open3.capture3(INCMP_ENV, BINARY, 'web-package')

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
