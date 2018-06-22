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

Object.include FF::PrintMethods

# Entry point of the tool.
#
# @param [ Array<String> ] args The ARGV array.
#
# @return [ Void ]
def __main__(*)
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
  puts "fifa #{FF::VERSION} - #{OS.sysname} #{OS.bits(:binary)}-Bit (#{OS.machine})" # rubocop:disable LineLength
end

# codebeat:disable[LOC]

# Print out how to use these tool.
#
# @return [ Void ]
def print_usage
  puts <<-USAGE

#{logo}

usage: fifa [options...] [matchers...]
Options:
-a=ATTRIBUTE    Show value of attribute
-f=FORMAT       Show formatted connection string
                Possible formats are jdbc, sqlplus, url, tns or pqdb
--no-color      Print errors without colors
-g, --group     Group planets by attribute value
-p, --pretty    Pretty print output as a table
-s, --sort      Print planets in sorted order
-t, --type      Show type of planet
-c, --count     Show count of matching planets
-h, --help      This help text
-v, --version   Show version number
USAGE
end

# Colorized logo of Orbit.
#
# @return [ String ]
def logo(color = OS.posix? ? 208 : :light_yellow)
  <<-LOGO.set_color(color)
          `-/++++++/:-`
      `/yhyo/:....-:/+syyy+:`
    .yd+`                `-+yds:     `
   om/                        -+``sdyshh.
  sd`                            hy    om
 /N.                             od.  `yd
 do                               /yyyy+`.`
`N:                                      /ms`
`M-                                        +m+
 m+                                         .+`
 od                                            +`
 .N:                     -oyyyyyo-             N.         +m.   /.
  om`                  -dy-     -yd-    `  .`  N. `.`           d/``
   hy                 -N-         -N-   Nss+/  Nys+/oh+   -m  -oNyoo
   `dy                yy           yy   N/     N-    `m:  -m    d:
    `dy               om           mo   N.     N.     h/  -m    d:
      yd.              hd.       .hh`   N.     N.    -N.  -m    d:
       +m:              :hho///ohh:     N.     Nys++sy-   -m    oh+o
        .dy`               .:::.                  ``              ``
          +m+
           `od+
             `od+`
               `+ds
LOGO
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
# @return [ Void ]
def log(*args)
  logger.add(*args)
end

# See FF::ErrorLogger#msg
#
# @return [ Void ]
def msg(*args)
  logger.msg(*args)
end
