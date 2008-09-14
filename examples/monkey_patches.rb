$:.unshift File.dirname(__FILE__)

require 'monkey_patches/original'
require 'monkey_patches/monkey_patch_1'
require 'monkey_patches/monkey_patch_2'

require 'example_helper'

show 'Klass'