require 'rye'
require 'sinatra'
require 'haml'
require 'sourcify'
require 'thin'

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
      @trace = []
      tracepoint = TracePoint.new(:call) do |t|
        @trace << "#{t.defined_class}.#{t.method_id}"
        @trace << "#{t.path}:#{t.lineno}"
      end
      tracepoint.enable
      @output = @block.call
      tracepoint.disable
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
module Manhattan
  class App < ::Sinatra::Base
    set server: 'thin', connections: []
    get '/' do
    ObjectSpace.each_object(Manhattan::Block) do |command|
      command.expire
      if params[:run] == command.name
        command.execute
      end
    end
    erb :index
    end
  end
end
