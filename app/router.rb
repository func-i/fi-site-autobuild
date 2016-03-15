before do
  request.body.rewind
  body_hash = JSON.parse request.body.read
  @payload = OpenStruct.new body_hash
end

post '/github_webhooks' do
  p @payload
  Handler.new(@payload).handle
  status 204
  body ''
end
