class Handler

  # GitHub account and branches
  GITHUB_ACC    = "func-i"
  GITHUB_REPO   = "fi-site-source"
  GITHUB_URL    = "https://github.com/#{GITHUB_ACC}/#{GITHUB_REPO}.git"
  GH_STAGING    = "staging"
  GH_PRODUCTION = "master"

  # temp folders on Heroku
  TEMP_DIR = "/tmp"
  CODE_DIR = "#{TEMP_DIR}/code"
  SITE_DIR = "#{TEMP_DIR}/site"

  def initialize(data)
    @repo_owner   = data.repository.owner.name
    @repo_name    = data.repository.name
    @repo_branch  = data.ref.sub("refs/heads/", "")
    @pusher       = data.pusher
  end

  def handle
    # handle only FI's GitHub account
    return unless @repo_owner === GITHUB_ACC

    # handle only the GitHub repo for FI's website
    return unless @repo_name === GITHUB_REPO

    # handle only push to staging or production branch
    return unless [GH_STAGING, GH_PRODUCTION].include? @repo_branch

    download
    set_env
    build
    publish
  end

  private

  def download
    %x{
      if [ -d #{CODE_DIR} ]; then
        cd #{CODE_DIR}
      else
        git clone #{GITHUB_URL} #{CODE_DIR} &&
        cd #{CODE_DIR} &&
        git config user.email "#{@pusher.email}" &&
        git config user.name "#{@pusher.name}"
      fi &&
      git checkout #{@repo_branch} &&
      git pull origin #{@repo_branch} &&
      cd -
    }
  end

  def set_env
    if @repo_branch === GH_STAGING
      @jekyll_config = "_config.yml,_config-staging.yml"
      @s3_config = "s3_config_staging"
    else # @repo_branch === GH_PRODUCTION
      @jekyll_config = "_config.yml,_config-production.yml"
      @s3_config = "s3_config_production"
    end
  end

  def build
    %x{
      cd #{CODE_DIR} &&
      bundle exec jekyll build -d #{SITE_DIR} --config #{@jekyll_config} &&
      cd -
    }
  end

  def publish
    %x{
      cd #{APP_ROOT.to_path} &&
      bundle exec s3_website push --site=#{SITE_DIR} --config-dir #{@s3_config}
    }
  end
end
