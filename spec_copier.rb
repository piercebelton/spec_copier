require 'net/http'
require 'uri'
require 'json'
require 'pry'


get_from = 'URL_HERE'
copy_to = 'URL_HERE'

ARGV.each do |path|
  get_uri = URI.parse(get_from + path)
  get_resp = Net::HTTP.get_response(get_uri)

  if get_resp.is_a?(Net::HTTPSuccess)
    post_path = path.split("/")[0...-1].join("/")
    post_uri = URI.parse(copy_to + post_path)
    http = Net::HTTP.new(post_uri.host, post_uri.port)
    post_request = Net::HTTP::Post.new(post_uri)
    post_request.content_type = 'application/json-patch+json'
    post_request.add_field 'accept', 'application/json'
    post_request.body = get_resp.body
    post_response = http.request(post_request)
    puts post_response.body
  else
    puts "#{path} not found on #{get_from}"
  end
end
