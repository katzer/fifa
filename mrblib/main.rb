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

@parser = OptParser.new do |opts|
  opts.add :attribute,  :string
  opts.add :format,     :string, 'default'
  opts.add :'no-color', :bool, false
  opts.add :group,      :bool, false
  opts.add :pretty,     :bool, false
  opts.add :sort,       :bool, false
  opts.add :type,       :bool, false
  opts.add :count,      :bool, false
end

@parser.on! :help do
  <<-USAGE
Usage: fifa [options...] [matchers...]
Options:
-a ATTRIBUTE    Show value of attribute
-f FORMAT       Show formatted connection string
                Possible formats are jdbc, sqlplus, url, tns or pqdb
-n, --no-color  Print errors without colors
-g, --group     Group planets by attribute value
-p, --pretty    Pretty print output as a table
-s, --sort      Print planets in sorted order
-t, --type      Show type of planet
-c, --count     Show count of matching planets
-h, --help      This help text
-v, --version   Show version number
USAGE
end

@parser.on! :version do
  "fifa #{Fifa::VERSION} - #{OS.sysname} #{OS.bits(:binary)}-Bit (#{OS.machine})" # rubocop:disable LineLength
end

# Entry point of the tool.
#
# @param [ Array<String> ] args The ARGV array.
#
# @return [ Void ]
def __main__(args)
  Fifa::Task.new($opts = parse(args[1..-1])).exec
  exit(1) if Fifa::Logger.errors?
end

# Parse the command-line arguments.
#
# @param [ Array<String> ] args The command-line arguments to parse.
#
# @return [ Hash<Symbol, Object> ]
def parse(args)
  opts = @parser.parse(args)

  opts[:tail] = @parser.tail
  opts[:tail] << 'id:.' if @parser.tail.empty?

  opts
end
