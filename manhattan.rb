#!/usr/bin/env ruby
require 'sinatra'
require 'rye'
require 'haml'

module Manhattan 
  class Command
    attr_accessor :output

    def self.all
      ObjectSpace.each_object(self)
    end

    def code &block
      @code = block
    end

    def execute
      @output = @code.call
    end
    
    def outout
      @output
    end
    
  end
end

def self.get_or_post(url,&block)
  get(url,&block)
  post(url,&block)
end

uptime = Manhattan::Command.new
uptime.code {
  Rye.shell :uptime
}

hostname = Manhattan::Command.new
hostname.code {
  Rye.shell :hostname
}

get_or_post '/' do
  uptime.execute
  hostname.execute
  @output = []
  ObjectSpace.each_object(Manhattan::Command) do |command|
    @output << command.output
  end
  #@output = uptime.output
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
