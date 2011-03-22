class ApplicationController < ActionController::Base
  protect_from_forgery
  
  protected
  
  def current_model(id = nil)
    @current_model ||= begin
      klass = controller_name.singularize.classify.constantize
      klass.find_by_id(id || params[:id])
    end
  end
    
  def back_or_403(error)
    respond_to do |wants|
      wants.html             { redirect_to :back, error: error }
      wants.any(:json, :xml) { head 403, error }
    end
  end
  
  def destroyed_redirect_to(loc, msg = nil)
    msg = t("#{controller_name}.destroyed") if msg.nil?
      
    respond_to do |wants|
      wants.html             { redirect_to loc, notice: msg }
      wants.any(:json, :xml) { head :ok }
    end
  end
  
  def notice(trans_key)
    flash[:notice] = t(trans_key)
  end
  
  def error(trans_key)
    flash[:error] = t(trans_key)
  end
  
  def unauthorized!(trans_key)
    raise Unauthorized, t(trans_key)
  end
  
  def ensure_exists(*objs)
    unauthorized!("#{}.#{action_name}_others") if objs.any?(&:blank?)
  end
end
