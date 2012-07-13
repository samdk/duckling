module AuthorizedHelper
  
  def link_to_log_out(text = 'Log Out')
    link_to text, logout_url, method: :delete
  end

end