class ApplicationController < ActionController::Base
  protect_from_forgery
  
  protected
  def back_or_403(error)
    respond_to do |wants|
      wants.html             { redirect_to :back, error: error }
      wants.any(:json, :xml) { head 403, error }
    end
  end
  
  def destroyed_redirect_to(loc, msg)
    respond_to do |wants|
      wants.html             { redirect_to loc, notice: msg }
      wants.any(:json, :xml) { head :ok }
    end
  end
end
