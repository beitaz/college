class UserPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def home?
    true
  end

  def profile?
    user.id == record.id || current_user.admin?
  end

  def setting?
    user.id == record.id || current_user.admin?
  end

  def home
    current_user.id == user.id
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
