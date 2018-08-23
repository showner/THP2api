module V1
  class CoursePolicy < ApplicationPolicy
    def update?
      record.creator == current_v1_user
    end

    def destroy?
      record.creator == current_v1_user
    end
  end
end
