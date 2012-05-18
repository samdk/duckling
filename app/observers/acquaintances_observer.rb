class AcquaintancesObserver < ActiveRecord::Observer
  observe :membership

  def after_create(membership)
    membership.user.ensure_acquaintances(membership.container.users)
  end
end
