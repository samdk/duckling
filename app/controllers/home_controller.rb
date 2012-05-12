class HomeController < AuthorizedController
  
  skip_login only: :landing
  
  before_filter do
    if logged_in?
      redirect_to '/activations/overview'
    end
  end
  
  def landing
    respond_to do |format|
      format.html {}
    end
  end
end