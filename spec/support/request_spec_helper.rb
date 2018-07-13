module RequestSpecHelper
  def response_from_json
    JSON.parse(response.body)
  end
end
