#\ -p 10021
require 'bundler'
Bundler.require
require './lib/manhattan'
require 'sass/plugin/rack'

Sass::Plugin.options[:style] = :compressed
use Sass::Plugin::Rack

run Manhattan::App
