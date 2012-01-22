$new_comment = $('.new-comment form')

$new_comment.live 'ajax:before', ->
  $(this).find('.new-comment-error').remove()


$new_comment.live 'ajax:error', (_, xhr) ->
  $("<div/>").prependTo($(this)).text(xhr.responseText).addClass('.new-comment-error')

$new_comment.live 'ajax:success', (event, data) ->
  $(this).find('.comment-input').val('')
  comments = $('.update-comments ul')
  comments.find("li").removeClass("fresh-comment")
  $("<li/>").appendTo(comments).html(data).addClass("fresh-comment")

$delete = $('.comment-delete')

$delete.live('ajax:beforeSend', -> $(this).parent().fadeOut())
       .live('ajax:error', -> $(this).parent().show())
       .live('ajax:success', -> $(this).parent().remove())