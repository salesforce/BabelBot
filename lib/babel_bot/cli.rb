#
# Copyright (c) 2016, salesforce.com, inc.
# All rights reserved.
# Licensed under the BSD 3-Clause license. 
# For full license text, see LICENSE.txt file in the repo root  or https://opensource.org/licenses/BSD-3-Clause
#

require "slop"

module BabelBot
  class CLI
    def self.run
      @opts = Slop.parse(help: true) do
        on '-v', 'Print the version' do
          puts "Version #{BabelBot::VERSION}"
        end

        command "generate-strings" do
          banner "Usage: babel-bot generate-strings CONFIG_PATH"
          run do |opts, args|
            if args[0]
              config = BabelBot::CLI.load_config(args[0])
              BabelBot::Runner.new(config).generate_strings
              exit
            end
          end
        end
      end

      puts @opts
      exit
    end

    def self.load_config(config_path)
      JSON.load(File.open(config_path))
    end
  end
end
