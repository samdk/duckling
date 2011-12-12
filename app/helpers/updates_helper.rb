module UpdatesHelper
  def delete_upload_link(upload_id)
    link_to(t('update.attached_files.delete'), "#", html: {
      'data-delete-upload' => 1,
      'data-upload'        => upload_id,
      'data-swap-text'     => t('update.attached_files.undelete')
    })
  end
end