before do
  request.body.rewind
  @payload = JSON.parse request.body.read
end

post '/github_webhooks' do
  p @payload
  Handler.new(@payload).handle
  status 204
  body ''
end
