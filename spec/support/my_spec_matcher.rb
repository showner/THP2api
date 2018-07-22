module MySpecMatcher
  extend RSpec::Matchers::DSL

  matcher :be_valid_uuid do
    match { |actual| /\A[[:xdigit:]]{8}-[[:xdigit:]]{4}-[[:xdigit:]]{4}-[[:xdigit:]]{4}-[[:xdigit:]]{12}\z/.match?(actual) }
  end

  matcher :be_json_utf8 do
    match do |actual|
      actual.headers["Content-Type"].casecmp?('application/json; charset=utf-8')
    rescue NoMethodError
      return false
    end
    failure_message do
      'expected Content-Type: ' + response.headers["Content-Type"] +
        ' to eq application/json; charset=utf-8'
    end
    failure_message_when_negated do
      'expected Content-Type: ' + response.headers["Content-Type"] +
        ' NOT to eq application/json; charset=utf-8'
    end
  end

  matcher :be_valid_date do
    match do |actual|
      date_format = '%Y-%m-%dT%H:%M:%S.%L%z' # FIXME: get it from DB format
      Date.strptime(actual, date_format)
    rescue ArgumentError
      return false
    end
  end
end
