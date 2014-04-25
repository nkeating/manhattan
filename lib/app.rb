class Manhattan::App < ::Sinatra::Application

  register Sinatra::AssetPack
  assets do
    # read on
    css :application, [
      '/css/manhattan.sass'
    ]
  end

  Repo = Manhattan::Repo.new
  require_all "#{Repo.path}/*.rb"

  get '/' do
    @status =  []
    @status << 'Repo.path:'
    @status << Repo.path
    @status << 'Origin:'
    @status << Repo.origin.to_s
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
    clear_blocks
    load_blocks
    redirect '/'
  end

  get '/styles.css' do
    scss 'scss/manhattan.scss'
  end
  
  def clear_blocks
    Manhattan::Block.all.delete_if {|obj| obj.name == 'Hostname'}
    Manhattan::Block.all.delete_if {|obj| obj.name == 'Uptime'}
    Manhattan::Block.all.delete_if {|obj| obj.name == 'Date'}
  end

  def load_blocks
    load_all "#{Repo.path}/*.rb"
  end

end
