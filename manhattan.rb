#!/usr/bin/env ruby
require 'rye'
require 'sinatra'
require 'haml'

module Manhattan 
  class Block
    attr_reader :output, :name
    attr_accessor :code
    
    def initialize name, &block
      @name = name
      @code = block
    end

    def self.all
      ObjectSpace.each_object(self)
    end
  
    def execute
      @output = @code.call
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

get_or_post '/' do
  @output = []
  ObjectSpace.each_object(Manhattan::Block) do |command|
    command.execute
    @output << command.name
    @output << command.output
  end
  haml :app
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
