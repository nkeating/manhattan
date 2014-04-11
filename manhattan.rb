#!/usr/bin/env ruby
require 'sinatra'
require 'rye'
require 'haml'
 
class Command
  attr_accessor :name, :code
  attr_reader :output

  def initialize( name ) 
    @name = name
  end
 
  def code
    yield( @output ) 
  end
 
  def execute
  end
 
end
 
post '/' do
  command = Command.new
  command.name = 'uptime'
  command.code {p "blorg"}
  @output = command.output
  haml :app
end

get '/' do
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
          %input.pink{:type => "text", :id => "cmd_to_run", :name => "cmd_to_run"}
          %input{:type => "submit", :value => "post!"}
