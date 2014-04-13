#!/usr/bin/env ruby
require 'rye'
require 'sinatra'
require 'haml'
require 'sourcify'

module Manhattan 
  class Block
    attr_reader :output, :name, :status
    attr_accessor :code
    
    def initialize name, &block
      @name = name
      @block = block
    end

    def self.all
      ObjectSpace.each_object(self)
    end
  
    def execute
      trace = TracePoint.new(:call) do |t|
        puts "#{t.defined_class}.#{t.method_id}"
        puts "#{t.path}:#{t.lineno}"
      end
      trace.enable
      @output = @block.call
      trace.disable
      @status = 'fresh'
    end
 
    def expire
      @status = 'stale'
    end

    def code
      @code = @block.to_raw_source(:strip_enclosure => true)
    end
  end
end

def self.get_or_post(url,&block)
  get(url,&block)
  post(url,&block)
end

uptime = Manhattan::Block.new('Uptime') do
  Rye.shell :uptime
end

hostname = Manhattan::Block.new('Hostname') do
  Rye.shell :hostname
end

date = Manhattan::Block.new('Date') do
  Rye.shell :date
end

get_or_post '/' do
  ObjectSpace.each_object(Manhattan::Block) do |command|
    command.expire
    if params[:run] == command.name
      command.execute
    end
  end
  erb :index
end
