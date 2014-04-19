module Manhattan
#end
#module Manhattan 
  class Manhattan::Block
    attr_reader :output, :name, :output_status, :trace
    attr_accessor :code
    @@instance_collector = []
    
    def initialize name, &block
      @name = name
      @block = block
      @@instance_collector << self
    end

    def self.all
      @@instance_collector
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
      @output_status = 'fresh'
    end
 
    def expire
      @output_status = 'stale'
    end

    def code
      @code = @block.to_raw_source(:strip_enclosure => true)
    end
  end
end
