require 'rye'
require 'sinatra'
require 'haml'
require 'sourcify'
require 'thin'
require 'require_all'

module Manhattan 
  class Block
    attr_reader :output, :name, :status, :trace
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

class Manhattan::App < ::Sinatra::Application
  require_all 'blocks/*.rb'
  get '/' do
    ObjectSpace.each_object(Manhattan::Block) do |command|
      command.expire
      if params[:run] == command.name
        command.execute
      end
    end
    erb :index
  end

  get '/refresh' do
    #code goes here to free all Blocks.code
    ObjectSpace.each_object(Manhattan::Block) do |command|
      #require_all 'blocks/*.rb'
      #Object.send(:remove_const, command.name.to_sym)
    end
    #load_all 'blocks/*.rb'
    redirect '/'
  end
end
