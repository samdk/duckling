class Unauthorized < RuntimeError ; end

module AuthorizedModel
  
  def permit_create?(*args)  ; true ; end
  def permit_read?(*args)    ; true ; end
  def permit_update?(*args)  ; true ; end
  def permit_destroy?(*args) ; true ; end
  
  def self.included(base)    
    base.before_destroy {|instance|
      instance.check_specific_permit(:permit_destroy?)
    }
    
    base.before_save :check_permits
    
    def base.cheating_create(*args)
      self.new(*args).tap {|x| x.skipping_auth!(&:save) }
    end
    
    def base.cheating_create!(*args)
      cheating_create(*args).tap {|x| x.instance_variable_set :@cheating, true }
    end
  end
  
  def check_permits
    check_specific_permit(new_record? ? :permit_create? : :permit_update?)
  end
  
  def check_specific_permit(func)
    if @cheating.blank? and not send(func, @notary, @notarizing_args)
      raise Unauthorized
    end
  end
  
  def skipping_auth!
    @cheating = true
    yield(self).tap { @cheating = false }
  end
  
  def authorize_with(user, args = {})
    @notary = user
    @notarizing_args = args
    self
  end
  alias_method :with_notary, :authorize_with

end
