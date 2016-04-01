class Handler

  # GitHub account and branches
  GITHUB_ACC    = "func-i"
  GITHUB_REPO   = "fi-site-source"
  GITHUB_URL    = "https://github.com/#{GITHUB_ACC}/#{GITHUB_REPO}.git"
  GH_STAGING    = "staging"
  GH_PRODUCTION = "master"

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

    Resque.enqueue(
      BuildQueue,
      GITHUB_URL,
      @pusher.email,
      @pusher.name,
      @repo_branch
    )
  end

end
