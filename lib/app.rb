class Manhattan::App < ::Sinatra::Application
  #require_all 'blocks/*.rb'
  require './blocks/hostname.manhattan.rb'
  require './blocks/uptime.manhattan.rb'
  require './blocks/date.manhattan.rb'
  get '/' do
    @status =  []
    @status << Manhattan::Block.all.count
    Manhattan::Block.all.each do |command|
      @status << command.name
      command.expire
      if params[:run] == command.name
        command.execute
      end
    end
    erb :index
  end

  get '/refresh' do
    refresh_status = []
    Manhattan::Block.all.delete_if {|obj| obj.name == 'Hostname'}
    Manhattan::Block.all.delete_if {|obj| obj.name == 'Uptime'}
    Manhattan::Block.all.delete_if {|obj| obj.name == 'Date'}
    #Manhattan::Block.all.each do |command|
    #  command.remove_instance
    #end
    load './blocks/hostname.manhattan.rb'
    load './blocks/uptime.manhattan.rb'
    load './blocks/date.manhattan.rb'
    redirect '/'
  end
end
