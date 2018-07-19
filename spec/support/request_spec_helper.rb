module RequestSpecHelper
  def response_from_json
    json = JSON.parse(response.body)
    if json.is_a?(Array)
      json.map!(&:with_indifferent_access)
    else
      json.with_indifferent_access
    end
  end
end
