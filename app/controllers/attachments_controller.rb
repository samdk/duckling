class AttachmentsController < AuthorizedController
  def show
    attachment = Attachment.find(params[:id])
    if current_user.can? read: attachment
      send_file attachment.path
    else
      raise Unauthorized, t('attachment.unauthorized')
    end
  end
end
