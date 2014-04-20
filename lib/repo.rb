class Manhattan::Repo

  DEFAULT_REPO_URL='https://github.com/nkeating/manhattan_blocks.git'

  def initialize repo_url=DEFAULT_REPO_URL
    @repo_url = repo_url
    @manhattan_dir = ENV['HOME']+'/.manhattan/'
    Dir.mkdir(@manhattan_dir) unless File.directory?(@manhattan_dir)
    @repo_dir = @manhattan_dir + 'repo/'
    if File.directory?(@repo_dir)
      Rugged::Repository.discover(@repo_dir)
    else
      Rugged::Repository.clone_at(repo_url, @repo_dir) 
    end
  end
 
  def path
    @repo_dir
  end
 
  def check_for_update
  end
 
end
