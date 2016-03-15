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

    @temp_dir = "/tmp"
    @code_dir = "#{@temp_dir}/code"
    @site_dir = "#{@temp_dir}/site"

    download
    build
    publish
  end

  private

  def download
    Dir.chdir(@temp_dir)
    %x{
      git clone #{@repo_url} #{@code_dir} &&
      cd #{@code_dir} &&
      git checkout #{@repo_branch} &&
      git pull origin #{@repo_branch} &&
      cd -
    }
  end

  def build
    %x{
      bundle exec jekyll build -s #{@code_dir} -d #{@site_dir} &&
      cd #{APP_ROOT.to_path}
    }
  end

  def publish
    puts Dir.pwd
    p Dir.entries(Dir.pwd)
    %x{
      bundle exec s3_website push --site=#{@site_dir}
    }
  end
end
