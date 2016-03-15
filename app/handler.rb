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

    @temp_dir  = "/tmp"
    download
    build
    publish
  end

  private

  def download
    @code_dir  = "#{@temp_dir}/code"
    Dir.chdir(@temp_dir)
    %x{
      git clone #{@repo_url} #{@code_dir} &&
      cd #{@code_dir} &&
      git checkout #{@repo_branch} &&
      git pull origin #{@repo_branch}
    }
  end

  def build
    @site_dir = "#{@temp_dir}/site"
    %x{
      bundle install &&
      bundle exec jekyll build -s #{@code_dir} -d #{@site_dir}
    }
  end

  def publish
    puts "Publishing!"
    Dir.chdir(@site_dir)
    p Dir.entries(@site_dir)
  end
end
