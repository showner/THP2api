class ApplicationPolicy
  attr_reader :current_v1_user, :record

  def initialize(current_v1_user, record)
    @current_v1_user = current_v1_user
    @record = record
  end

  # def index?
  #   false
  # end

  # def show?
  #   false
  # end

  # def create?
  #   false
  # end

  # def new?
  #   create?
  # end

  # def update?
  #   false
  # end

  # def edit?
  #   update?
  # end

  # def destroy?
  #   false
  # end

  # class Scope
  #   attr_reader :user, :scope

  #   def initialize(user, scope)
  #     @user = user
  #     @scope = scope
  #   end

  #   def resolve
  #     scope.all
  #   end
  # end
end
