class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    user.role ||=Role.new
    if user.role.name == 'admin'
      can :manage, :all
      can :access, :rails_admin
      can :dashboard      
    elsif user.role.name == 'user'
      can :access, :rails_admin
      can :dashboard
      can :manage, User, :id => user.id
      cannot :destroy, User
      cannot :create, User
    end
  end
end
