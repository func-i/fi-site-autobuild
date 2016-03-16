class Handler

  # GitHub account and branches
  GITHUB_ACC  = "func-i"
  STAGING     = "staging"
  PRODUCTION  = "master"

  # Amazon S3 bucket for staging, Heroku env var for the bucket
  S3_STAGING = "fi-website-staging"
  BUCKET_ENV = "AWS_S3_BUCKET"

  # temp folders on Heroku
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
    set_env
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

  def set_env
    if @repo_branch === STAGING
      @jekyll_config = "_config.yml,_config-staging.yml"
      @s3_config = "s3_config_staging"
    else # @repo_branch === PRODUCTION
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
