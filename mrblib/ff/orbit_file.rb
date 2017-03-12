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

module FF
  # Extracted code to deal with the orbit json file
  class OrbitFile
    # File separator
    SEPARATOR = OS.windows? ? '\\' : '/'

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
      [ENV.fetch('ORBIT_HOME'), 'config', 'orbit.json'].join(SEPARATOR)
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
