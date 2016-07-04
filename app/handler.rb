class Handler

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

    # handle only push to staging, production or demo branch
    return unless [GH_STAGING, GH_PRODUCTION, GH_DEMO].include? @repo_branch

    Resque.enqueue(
      BuildQueue,
      GITHUB_URL,
      @pusher.email,
      @pusher.name,
      @repo_branch
    )
  end

end
