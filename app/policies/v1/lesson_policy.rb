module V1
  class LessonPolicy < ApplicationPolicy
    def update?
      # binding.pry
      record.creator == user
    end

    def destroy?
      # binding.pry
      record.creator == user
    end
  end
end
