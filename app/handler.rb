class Handler
  def initialize(data)
    @repo_owner  = data.repository.owner.name
    @repo_name   = data.repository.name;
    @repo_url    = "https://github.com/func-i/#{@repo_name}.git"
    @repo_branch = data.ref.sub("refs/heads/", "");
  end

  def handle
    # handle only FI's GitHub account: func-i
    return unless @repo_owner === "func-i"

    # handle only push to master or staging branch
    return unless ["master", "staging"].include? @repo_branch

    @temp_dir = "/tmp"
    @code_dir = "#{@temp_dir}/code"
    @site_dir = "#{@temp_dir}/site"

    download
    build
    publish
  end

  private

  def download
    %x{
      if [ ! -d #{@code_dir} ]; then
        git clone #{@repo_url} #{@code_dir}
      fi &&
      cd #{@code_dir} &&
      git checkout #{@repo_branch} &&
      git pull origin #{@repo_branch} &&
      cd -
    }
  end

  def build
    %x{
      bundle exec jekyll build -s #{@code_dir} -d #{@site_dir} &&
      cd #{@site_dir}
    }
  end

  def publish
    %x{
      cd #{APP_ROOT.to_path} &&
      bundle exec s3_website push --site=#{@site_dir}
    }
  end
end
