class AcquaintancesObserver < ActiveRecord::Observer
  observe :membership

  def after_create(membership)
    membership.ensure_acquaintances(membership.container.users)
  end
end
