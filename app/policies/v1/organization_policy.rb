module V1
  class OrganizationPolicy < ApplicationPolicy
    def update?
      record.creator == user
    end

    def destroy?
      record.creator == user
    end
  end
end
