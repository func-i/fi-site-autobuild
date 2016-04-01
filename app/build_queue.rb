class BuildQueue

  @queue = :auto_build

  def self.perform(github_url, pusher_email, pusher_name, repo_branch)
    download(github_url, pusher_email, pusher_name, repo_branch)
    jekyll_config, s3_config = set_env(repo_branch)
    puts 'before build'
    puts jekyll_config
    puts s3_config
    build(jekyll_config)
    publish(s3_config)
  end

  def self.download(github_url, pusher_email, pusher_name, repo_branch)
    puts 'starting download'

    %x{
      if [ -d #{CODE_DIR} ]; then
        cd #{CODE_DIR}
      else
        git clone #{github_url} #{CODE_DIR} &&
        cd #{CODE_DIR} &&
        git config user.email "#{pusher_email}" &&
        git config user.name "#{pusher_name}"
      fi &&
      git checkout #{repo_branch} &&
      git pull origin #{repo_branch} &&
      cd -
    }
  end

  def self.set_env(repo_branch)
    puts 'starting set_env'

    if repo_branch == GH_STAGING
      jekyll_config = "_config.yml,_config-staging.yml"
      s3_config = "s3_config_staging"
    else # repo_branch === GH_PRODUCTION
      jekyll_config = "_config.yml,_config-production.yml"
      s3_config = "s3_config_production"
    end

    puts 'finishing set_env'
    return jekyll_config, s3_config
  end

  def self.build(jekyll_config)
    puts 'starting build'

    %x{
      cd #{CODE_DIR} &&
      bundle exec jekyll build -d #{SITE_DIR} --config #{jekyll_config} &&
      cd -
    }
  end

  def self.publish(s3_config)
    puts 'starting publish'

    %x{
      cd #{APP_ROOT.to_path} &&
      bundle exec s3_website push --site=#{SITE_DIR} --config-dir #{s3_config} &&
      cd -
    }

    puts 'ending all'
  end
end
