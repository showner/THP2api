module MySpecHelper
  def response_from_json
    json = JSON.parse(response.body)
    if json.is_a?(Array)
      json.map!(&:with_indifferent_access)
    else
      json.with_indifferent_access
    end
  end

  def test_user(trait)
    @test_user ||= create(:user, trait)
  end

  def fake_user(trait = nil)
    request.headers.merge! test_user(trait).create_new_auth_token
  end
end
