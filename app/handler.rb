class Handler

  GITHUB_ACC  = "func-i"
  STAGING     = "staging"
  PRODUCTION  = "master"

  TEMP_DIR = "/tmp"
  CODE_DIR = "#{TEMP_DIR}/code"
  SITE_DIR = "#{TEMP_DIR}/site"

  def initialize(data)
    @repo_owner  = data.repository.owner.name
    @repo_name   = data.repository.name;
    @repo_url    = "https://github.com/#{GITHUB_ACC}/#{@repo_name}.git"
    @repo_branch = data.ref.sub("refs/heads/", "");
  end

  def handle
    # handle only FI's GitHub account: func-i
    return unless @repo_owner === GITHUB_ACC

    # handle only push to staging or production branch
    return unless [STAGING, PRODUCTION].include? @repo_branch

    download
    build
    publish
  end

  private

  def download
    %x{
      if [ ! -d #{CODE_DIR} ]; then
        git clone #{@repo_url} #{CODE_DIR}
      fi &&
      cd #{CODE_DIR} &&
      git checkout #{@repo_branch} &&
      git pull origin #{@repo_branch} &&
      cd -
    }
  end

  def build
    config_files = "_config.yml,_config-staging.yml"
    %x{
      cd #{CODE_DIR} &&
      bundle exec jekyll build -d #{SITE_DIR} --config #{config_files} &&
      cd -
    }
  end

  def publish
    %x{
      cd #{APP_ROOT.to_path} &&
      bundle exec s3_website push --site=#{SITE_DIR}
    }
  end
end
