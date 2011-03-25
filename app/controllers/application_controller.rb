class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  
  protected
  
  def current_model(id = nil)
    @current_model ||= begin
      klass = controller_name.singularize.classify.constantize
      klass.find_by_id(id || params[:id])
    end
  end
    
  def render_404
    respond_to do |wants|
      wants.html { render status: 404, file: "#{Rails.root}/public/404.html" }
      wants.any  { head 404, t('errors.notfound') }
    end
  end  
  
  def back_or_403(error)
    respond_to do |wants|
      wants.html { redirect_to :back, error: error }
      wants.any  { head 403, error }
    end
  end
  
  def destroyed_redirect_to(loc, msg = nil)
    msg = t("#{controller_name.singularize}.destroyed") if msg.nil?
      
    respond_to do |wants|
      wants.html             { redirect_to loc, notice: msg }
      wants.any(:json, :xml) { head :ok }
    end
  end
  
  def notice(trans_key, *args)
    flash[:notice] = t(trans_key, *args)
  end
  
  def error(trans_key)
    flash[:error] = t(trans_key)
  end
  
  def unauthorized!(trans_key)
    raise Unauthorized, t(trans_key)
  end
end
