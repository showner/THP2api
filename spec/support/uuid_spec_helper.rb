module UuidSpecHelper
  extend RSpec::Matchers::DSL

  matcher :be_valid_uuid do
    match {|actual| /\A[[:xdigit:]]{8}-[[:xdigit:]]{4}-[[:xdigit:]]{4}-[[:xdigit:]]{4}-[[:xdigit:]]{12}\z/.match?(actual) }
  end
end
