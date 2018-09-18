# == Schema Information
#
# Table name: ressources
#
#  id         :uuid             not null, primary key
#  label      :string(50)
#  uri        :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_ressources_on_label  (label)
#  index_ressources_on_uri    (uri) UNIQUE
#

require 'rails_helper'

RSpec.describe Ressource, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
