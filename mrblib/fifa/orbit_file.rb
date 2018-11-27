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

module Fifa
  # Extracted code to deal with the orbit json file
  class OrbitFile
    # File separator
    SEP = OS.windows? ? '\\' : '/'

    # The JSON encoded file content.
    #
    # @return [ Object ]
    def self.parse
      new.parse
    end

    # The file path where to find the ORBIT_FILE.
    # Raises an error if the env variable is not set.
    #
    # @return [ String ]
    def path
      return ENV['ORBIT_FILE'] if ENV.include? 'ORBIT_FILE'

      [ENV.fetch('ORBIT_HOME'), 'config', 'orbit.json'].join(SEP)
    rescue KeyError
      raise 'env ORBIT_HOME not set'
    end

    # The raw content of the file.
    #
    # @return [ String ]
    def raw
      content = ''
      File.open(path) { |f| content = f.read }
      content
    rescue IOError
      raise "cannot open #{path}"
    end

    # The JSON encoded file content.
    #
    # @return [ Object ]
    def parse
      JSON.parse(raw)
    rescue RuntimeError
      raise "cannot read from #{path}"
    end
  end
end
