# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'simplecov'
SimpleCov.start

require 'coveralls'
Coveralls.wear!

require 'convenient'
require 'json'
require 'pry'
require 'minitest/autorun'
