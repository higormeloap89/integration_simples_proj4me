require "uri"
require "json"
require "net/http"
require_relative 'main'

class Connect < Main
  def initialize(url)
    @url = URL + url
  end

  def authentication
    begin
      url = URI(@url)
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true

      request = Net::HTTP::Post.new(url)
      request["accept"] = "application/json"
      request["Content-Type"] = "application/json"
      request.body = JSON.dump({
                                 "username": USER,
                                 "password": PASS
                               })

      response = https.request(request)

      case response
      when Net::HTTPOK
        $token = JSON.parse(response.body)['token']
        "Success"
      when Net::HTTPClientError,
        Net::HTTPInternalServerError
        "Unauthorized"
      else
        "Error internal"
      end
    rescue Net::OpenTimeout => e
      "Timed out while trying to connect #{e}"
    end
  end
end
