# ## Schema Information
#
# Table name: `lessons`
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`id`**           | `uuid`             | `not null, primary key`
# **`description`**  | `text`             |
# **`title`**        | `string(50)`       | `not null`
# **`created_at`**   | `datetime`         | `not null`
# **`updated_at`**   | `datetime`         | `not null`
#

FactoryBot.define do
  factory :lesson do
    title { Faker::Educator.course.first(50) }
    description { Faker::FamilyGuy.quote.first(300) }
  end
end
