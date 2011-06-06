class Unauthorized < RuntimeError ; end

module AuthorizedModel
  
  def permit_create?(*args)  ; true ; end
  def permit_read?(*args)    ; true ; end
  def permit_update?(*args)  ; true ; end
  def permit_destroy?(*args) ; true ; end
  
  def self.included?(base)
    base.validate :check_permits
    
    base.before_destroy {|instance|
      instance.check_specific_permit(:permit_destroy?)
    }
  end
  
  def check_permits
    func = new_record? ? :permit_create? : :permit_update?

    check_specific_permit func
    
    true
  end
  
  def check_specific_permit(func)
    if @cheating.blank? and not send(func, @notary, @notarizing_args)
      raise Unauthorized
    end
  end
  
  
  
  # TODO: use validation hooks instead of this cheatery
  # 
  # 
  # def create
  #   begin
  #     if @cheating.blank? and not permit_create?(@notary, @notarizing_args)
  #       raise Unauthorized
  #     end
  #   rescue
  #     raise Unauthorized
  #   end
  #   
  #   super
  # end
  # 
  # def update
  #   begin
  #     if @cheating.blank? and not permit_update?(@notary, @notarizing_args)
  #       raise Unauthorized
  #     end
  #   rescue
  #     raise Unauthorized
  #   end
  #   
  #   super
  # end
  # 
  # def destroy
  #   begin
  #     if @cheating.blank? and not permit_destroy?(@notary, @notarized_args)
  #       raise Unauthorized
  #     end
  #   rescue
  #     raise Unauthorized
  #   end
  #   
  #   super
  # end
  
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
