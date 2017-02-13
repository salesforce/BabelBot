# coding: utf-8

#
# Copyright (c) 2016, salesforce.com, inc.
# All rights reserved.
# Licensed under the BSD 3-Clause license. 
# For full license text, see LICENSE.txt file in the repo root  or https://opensource.org/licenses/BSD-3-Clause
#

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'babel_bot/version'

Gem::Specification.new do |spec|
  spec.name          = "babel_bot"
  spec.version       = BabelBot::VERSION
  spec.authors       = ["Nick Changnon"]
  spec.email         = ["nchangnon@salesforce.com"]

  spec.summary       = %q{gem to generate localization string files from a Google Spreadsheet}
  spec.homepage      = "https://github.com/salesforce/BabelBot"
  spec.license       = "BSD-3-Clause"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = ["babel-bot"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "activesupport", "~> 4.2.4"

  spec.add_runtime_dependency "google-api-client", "~> 0.8.6"
  spec.add_runtime_dependency "slop", "~> 3.6.0"
  spec.add_runtime_dependency "twine", "~> 0.6.0"
end
