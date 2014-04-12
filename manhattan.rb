#!/usr/bin/env ruby
require 'sinatra'
require 'rye'
require 'haml'

module Manhattan 
  class Command
    attr_accessor :output

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

get_or_post '/' do
  command = Manhattan::Command.new
  command.code {
    Rye.shell :ls, '-l $HOME'
    Rye.shell :uptime
  }
  command.execute
  @output = command.output
  haml :app
end

__END__
@@ app
%html
  %head
    %title Manhattan
    %script{:type => 'text/javascript', :src => 'http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js'}
    :javascript
      });
  %body
    #footer
      %h2 Output:
      %p= @output
      %form{:action => '/', :method => "post"}
        %p
          %input{:type => "submit", :value => "post!"}
