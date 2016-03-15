class Handler
  def initialize(data)
    @repo_owner  = data.repository.owner.name
    @repo_name   = data.repository.name;
    @repo_url    = "https://github.com/func-i/#{@repo_name}.git"
    @repo_branch = data.ref.replace("refs/heads/", "");
  end

  def handle
    # end early if not FI account
    return unless @repo_owner === "func-i"

    temp_dir  = "./temp"
    @code_dir  = "#{temp_dir}/code"
    @site_dir  = "#{temp_dir}/site"

    build
    publish
  end

  private

  def build
    %x{
      echo "building branch #{repo_branch} of #{repo_url}" &&
      pwd
    }
  end

  def publish
    %x{
      echo "publishing" &&
      pwd
    }
  end
end
