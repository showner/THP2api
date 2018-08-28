module MySpecHelper
  def response_from_json
    @response_from_json ||= begin
      json = JSON.parse(response.body)
      if json.is_a?(Array)
        json.map!(&:with_indifferent_access)
      else
        json.with_indifferent_access
      end
    end
  end

  def test_user(trait = nil, **attributes)
    @test_user ||= create(:user, trait, **attributes)
  end

  def fake_user(trait = nil, **attributes)
    request.headers.merge! test_user(trait, **attributes).create_new_auth_token
  end
end
