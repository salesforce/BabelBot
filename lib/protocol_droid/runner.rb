#
# Copyright (c) 2016, salesforce.com, inc.
# All rights reserved.
# Licensed under the BSD 3-Clause license. 
# For full license text, see LICENSE.txt file in the repo root  or https://opensource.org/licenses/BSD-3-Clause
#

module ProtocolDroid
  class Runner
    def initialize(config)
      @config = config
    end

    def generate_strings
      twine_file_path = @config['twineFilePath']
      csv = ProtocolDroid::CSVLoader.new(@config).load
      ProtocolDroid::TwineGenerator.new(csv, twine_file_path).generate
      system "twine generate-all-string-files #{twine_file_path} #{@config['projectLocalesPath']}"
    end
  end
end
