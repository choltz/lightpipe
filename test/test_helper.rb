require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'lightpipe'
require 'minitest/autorun'
require 'mocha/setup'
require 'shoulda'
require 'byebug'
