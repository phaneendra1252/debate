class Ability

  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user
    if user.role? :admin
      can :manage, :all
    elsif user.role? :moderator
      can :read, :all
      can :create, Article
      can :update, Article do |record|
        record.try(:user) == user
      end
      can :destroy, Article do |record|
        record.try(:user) == user
      end
      can :create, Comment
      can :update, Comment do |record|
        record.try(:user) == user
      end
      can :destroy, Comment do |record|
        record.try(:user) == user
      end
    else
      can :read, :all
    end
  end

end
