class AssetsController < AuthorizedController

  def avatar    
    if current_user.acquaintance_ids.include?(params[:id])
      send_file "#{Rails.root}/attachments/avatars/#{params[:style]}/#{params[:id]}.png", disposition: 'inline'
    else
      render status: 500
    end
  end
  
  def attachments
    attachment, id, style, filename = params.slice(:attachment, :id, :style, :filename)
    # TODO: can the user access this file?
    
    send_file "#{Rails.root}/attachments/#{attachment}/#{id}/#{style}/#{filename}", disposition: 'attachment'
  end
  
end
