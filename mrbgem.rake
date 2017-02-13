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

require_relative 'mrblib/ff/version'

gem = MRuby::Gem::Specification.new('ff') do |spec|
  spec.bins = ['ff']

  spec.add_dependency 'mruby-os', github: 'appplant/mruby-os'

  spec.add_dependency 'mruby-terminal-table'
  spec.add_dependency 'mruby-print'
  spec.add_dependency 'mruby-exit'
  spec.add_dependency 'mruby-env'
  spec.add_dependency 'mruby-io'
  spec.add_dependency 'mruby-json'
end

gem.license = 'Apache 2.0'
gem.author  = 'Sebastián Katzer, appPlant GmbH'
gem.summary = 'Fastest way to find informations about planets'
gem.version = FF::VERSION
