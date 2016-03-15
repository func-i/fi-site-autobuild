before do
  request.body.rewind
  # body_hash = JSON.parse request.body.read
  # @payload = OpenStruct.new body_hash
  req_json = request.body.read
  @payload = JSON.parse(req_json, object_class: OpenStruct)
end

post '/github_webhooks' do
  p @payload
  Handler.new(@payload).handle
  status 204
  body ''
end
