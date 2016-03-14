module Handler
  def handle(data)
    repo_owner  = data.repository.owner.name
    # end early if not FI account
    return unless repo_owner === "func-i"

    repo_name   = data.repository.name;
    repo_branch = data.ref.replace("refs/heads/", "");
    repo_url    = "https://github.com/func-i/#{repo_name}.git"

    temp_dir  = "./temp"
    code_dir  = "#{temp_dir}/code"
    site_dir  = "#{temp_dir}/site"

    params = [repo_name, repo_branch, repo_owner, repo_url, code_dir, site_dir]
  end
end
