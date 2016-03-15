class Handler
  def initialize(data)
    @repo_owner  = data.repository.owner.name
    @repo_name   = data.repository.name;
    @repo_url    = "https://github.com/func-i/#{@repo_name}.git"
    @repo_branch = data.ref.sub("refs/heads/", "");
  end

  def handle
    # end early if not FI account
    return unless @repo_owner === "func-i"

    build
    publish
  end

  private

  def build
    temp_dir  = "/temp"
    code_dir  = "#{temp_dir}/code"
    @site_dir = "#{temp_dir}/site"

    Dir.mkdir(temp_dir)
    Dir.chdir(temp_dir)
    puts Dir.pwd

    %x{
      git clone #{@repo_url} #{code_dir}
      &&
      ls
    }
  end

  def publish
    puts "Publishing!"
  end
end
