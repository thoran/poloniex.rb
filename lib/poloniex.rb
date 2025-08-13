# poloniex.rb

lib_dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

module Poloniex; end

require 'Poloniex/Configuration'
require 'Poloniex/V1'
require 'Poloniex/VERSION'
