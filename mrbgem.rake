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

require_relative 'mrblib/fifa/version'

MRuby::Gem::Specification.new('fifa') do |spec|
  spec.license = 'Apache 2.0'
  spec.author  = 'Sebastián Katzer, appPlant GmbH'
  spec.version = Fifa::VERSION
  spec.bins    = ['fifa']

  spec.add_dependency 'mruby-planet-matcher',  github: 'katzer/mruby-planet-matcher'
  spec.add_dependency 'mruby-terminal-table',  mgem: 'mruby-terminal-table'
  spec.add_dependency 'mruby-ansi-colors',     mgem: 'mruby-ansi-colors'
  spec.add_dependency 'mruby-tiny-io',         mgem: 'mruby-tiny-io'
  spec.add_dependency 'mruby-print',           core: 'mruby-print'
  spec.add_dependency 'mruby-exit',            core: 'mruby-exit'
  spec.add_dependency 'mruby-env',             mgem: 'mruby-env'
  spec.add_dependency 'mruby-os',              mgem: 'mruby-os'
  spec.add_dependency 'mruby-json',            mgem: 'mruby-json'
  spec.add_dependency 'mruby-array-ext',       core: 'mruby-array-ext'
  spec.add_dependency 'mruby-regexp-pcre',     mgem: 'mruby-regexp-pcre'
  spec.add_dependency 'mruby-tiny-opt-parser', mgem: 'mruby-tiny-opt-parser'
end
