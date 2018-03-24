class CoursePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def new?
    true
  end

  def edit?
    true
  end
  
  class Scope < Scope
    def resolve
      scope
    end
  end
end
