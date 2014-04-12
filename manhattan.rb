#!/usr/bin/env ruby
require 'sinatra'
require 'rye'
require 'haml'

module Manhattan 
  class Command
    attr_accessor :output

    def self.all
      ObjectSpace.each_object(self).to_a
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

get_or_post '/' do
  uptime.execute
  commands = Manhattan::Command.all.methods
  @output = commands
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
