class Unauthorized < RuntimeError ; end

module AuthorizedModel
  
  def permit_create?(*args)  ; true ; end
  def permit_read?(*args)    ; true ; end
  def permit_update?(*args)  ; true ; end
  def permit_destroy?(*args) ; true ; end
  
  def create
    if @cheating.blank? and permit_create?(@notary, @notarizing_args)
      raise Unauthorized
    end
    
    super
  end
  
  def update
    if @cheating.blank? and permit_update?(@notary, @notarizing_args)
      raise Unauthorized
    end
    
    super
  end
  
  def destroy
    if @cheating.blank? and permit_destroy?(@notary, @notarized_args)
      raise Unauthorized
    end
    
    super
  end
  
  def ignore_permissions!
    @cheating = true
    self
  end
  
  def authorize_with(user, args = {})
    @notary = user
    @notarizing_args = args
    self
  end
  alias_method :with_notary, :authorize_with

end
