#!/usr/bin/env ruby
require './lib/manhattan.rb'

uptime = Manhattan::Block.new('Uptime') do
  Rye.shell :uptime
end

hostname = Manhattan::Block.new('Hostname') do
  Rye.shell :hostname
end

date = Manhattan::Block.new('Date') do
  Rye.shell :date
end

foobar = Manhattan::Block.new('Foo') do
  foo='hello'
  bar='world'
  c='cruel'
  'boop'
end

run Manhattan::App.run!
