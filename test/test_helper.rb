#
# Copyright (c) 2016, salesforce.com, inc.
# All rights reserved.
# Licensed under the BSD 3-Clause license. 
# For full license text, see LICENSE.txt file in the repo root  or https://opensource.org/licenses/BSD-3-Clause
#

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'babel_bot'

require 'minitest/autorun'
require 'minitest/reporters'
require 'mocha/mini_test'
require 'pry-byebug'

Minitest::Reporters.use!
