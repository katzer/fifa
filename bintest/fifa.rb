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

require 'open3'
require 'json'
require_relative '../mrblib/ff/version'

def orbit_env_get(file = nil)
  if file
    { 'ORBIT_FILE' => File.expand_path("config/#{file}.json", __dir__) }
  else
    { 'ORBIT_HOME' => __dir__ }
  end
end

BINARY    = File.expand_path('../mruby/bin/fifa', __dir__)

ORBIT_ENV = orbit_env_get.freeze
PASWD_ENV = orbit_env_get('orbit.password').freeze
INCMP_ENV = orbit_env_get('orbit.incomplete').freeze
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

assert('unknown flag') do
  _, output, status = Open3.capture3(BINARY, '-unknown')

  assert_false status.success?, 'Process did exit cleanly'
  assert_include output, 'unknown option'
end

assert('unknown planet') do
  output, status = Open3.capture2(ORBIT_ENV, BINARY, 'unknown')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_true output.empty?
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

assert('matchers') do
  output, = Open3.capture2(ORBIT_ENV, BINARY, '@my-db')
  assert_equal output.split.count, 1
  output, = Open3.capture2(ORBIT_ENV, BINARY, '@id=my-db')
  assert_equal output.split.count, 1
  output, = Open3.capture2(ORBIT_ENV, BINARY, '%my-db')
  assert_equal output.split.count, 2
  output, = Open3.capture2(ORBIT_ENV, BINARY, 'my-db@type=db')
  assert_equal output.split.count, 1
  output, = Open3.capture2(ORBIT_ENV, BINARY, 'my-db%type=db')
  assert_equal output.split.count, 0
  output, = Open3.capture2(ORBIT_ENV, BINARY, '%type:^(?!.*db).*$')
  assert_equal output.split.count, 1
  output, = Open3.capture2(ORBIT_ENV, BINARY, '@type:db|web')
  assert_equal output.split.count, 2
  output, = Open3.capture2(ORBIT_ENV, BINARY, 'tags:gfv3@tags:sles11')
  assert_equal output.split.count, 1
end

assert('count') do
  output, = Open3.capture2(ORBIT_ENV, BINARY, '-c', 'my-db')
  assert_include output, '1'
  output, = Open3.capture2(ORBIT_ENV, BINARY, '--count', 'type:db|web')
  assert_include output, '2'
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

assert('missing type') do
  output, status = Open3.capture2(INCMP_ENV, BINARY, '-t', 'missing-type')

  assert_false status.success?, 'Process did exit cleanly'
  assert_false output.empty?
end

assert('sorted output [-s]') do
  output, = Open3.capture2(ORBIT_ENV, BINARY, '-s', '-t', 'my-web', 'my-app')

  assert_include output.split.first, 'server'
  assert_include output.split.last, 'web'
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
  output, status = Open3.capture2(ORBIT_ENV, BINARY, '-f=sqlplus', 'my-db')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, 'user1@"@(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=host1.bla)(PORT=666)))(CONNECT_DATA=(SID=horst1)))"' # rubocop:disable LineLength
end

assert('sqlplus format with password') do
  output, status = Open3.capture2(PASWD_ENV, BINARY, '-f=sqlplus', 'my-db')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, 'user1/uwish@"@(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=host1.bla)(PORT=666)))(CONNECT_DATA=(SID=horst1)))"' # rubocop:disable LineLength
end

assert('pqdb format') do
  output, status = Open3.capture2(ORBIT_ENV, BINARY, '-f=pqdb', 'my-db')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, 'OP_DB:user1@url1.de'
end

assert('ski format') do
  output, status = Open3.capture2(ORBIT_ENV, BINARY, '-f=ski')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, '1|my-app|server|Server|user1@url1.de'
  assert_include output, '1|my-db|db|Database|OP_DB:user1@url1.de'
  assert_include output, '1|my-web|web|Webserver|https://url.1.net'

  output, status = Open3.capture2(INCMP_ENV, BINARY, '-f=ski')

  assert_false status.success?, 'Process did exit cleanly'
  assert_include output, '0|my-app|server||'
  assert_include output, '0|my-db|db||'
  assert_include output, '0|my-web|web||'
end

assert('json format') do
  output, status = Open3.capture2(ORBIT_ENV, BINARY, '-f=json', 'my-app')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_nothing_raised { JSON.parse output }
  assert_kind_of Hash, JSON.parse(output)
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

assert('incomplete server') do
  output, status = Open3.capture2(INCMP_ENV, BINARY, 'my-app')

  assert_false status.success?, 'Process did exit cleanly'
  assert_include output, 'missing'
end

assert('incomplete db') do
  output, status = Open3.capture2(INCMP_ENV, BINARY, 'my-db')

  assert_false status.success?, 'Process did exit cleanly'
  assert_include output, 'missing'
end

assert('incomplete web') do
  output, status = Open3.capture2(INCMP_ENV, BINARY, 'my-web')

  assert_false status.success?, 'Process did exit cleanly'
  assert_include output, 'missing'
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
