before do
  request.body.rewind
  @payload = JSON.parse request.body.read
end

post '/github_webhooks' do
  p @payload
  GithubConnect::Webhook.new(env['HTTP_X_GITHUB_EVENT'], @request_payload).handle
  status 204
  body ''
end
