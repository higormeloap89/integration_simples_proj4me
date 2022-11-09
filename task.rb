require "uri"
require "json"
require "net/http"

class Task < Main
  def initialize(project_id)
    @project_id = project_id
    @url_task = URL + "ws/int/api/pvt/projects/#{project_id}/"
  end

  def all
    url = URI(@url_task + 'tasks')
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["Authorization"] = "Bearer #{$token}"

    response = https.request(request)

    case response
    when Net::HTTPOK
      JSON.parse response.read_body
    when Net::HTTPClientError,
      Net::HTTPInternalServerError
      "Not Found"
    else
      "Error internal"
    end
  end

  def show(task_id)
    url = URI(@url_task + "tasks/#{task_id}")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["Authorization"] = "Bearer #{$token}"

    response = https.request(request)

    case response
    when Net::HTTPOK
      JSON.parse response.read_body
    when Net::HTTPClientError,
      Net::HTTPInternalServerError
      "Not Found"
    else
      "Error internal"
    end
  end

  def tags(task_id)
    url = URI(@url_task + "tasks/#{task_id}/tags")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["Authorization"] = "Bearer #{$token}"

    response = https.request(request)

    case response
    when Net::HTTPOK
      JSON.parse response.read_body
    when Net::HTTPClientError,
      Net::HTTPInternalServerError
      "Not Found"
    else
      "Error internal"
    end
  end
end
