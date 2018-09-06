class UuidValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    matching = (value =~ /\A[[:xdigit:]]{8}-[[:xdigit:]]{4}-[[:xdigit:]]{4}-[[:xdigit:]]{4}-[[:xdigit:]]{12}\z/)
    record.errors.add attribute, (options[:message] || "is not an uuid") unless matching
  end
end
