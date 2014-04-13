#!/usr/bin/env ruby
require 'rye'
require 'sinatra'
require 'haml'
require 'sourcify'

module Manhattan 
  class Block
    attr_reader :output, :name
    attr_accessor :code
    
    def initialize name, &block
      @name = name
      @block = block
    end

    def self.all
      ObjectSpace.each_object(self)
    end
  
    def execute
      @output = @block.call
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
    command.execute
  end
  erb :index
end

__END__
@@ app
%html
  %head
    %title Manhattan
  %body
    %h2 Output:
    %p= @output
    %form{:action => '/', :method => "post"}
      %p
        %input{:type => "submit", :value => "post!"}
