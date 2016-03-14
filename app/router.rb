before do
  request.body.rewind
  @payload = JSON.parse request.body.read
end

post '/github_webhooks' do
  p @payload
  Handler::handle(@payload)
  status 204
  body ''
end
