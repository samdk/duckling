$ ->
  $('a[data-delete-upload]').live 'click', ->
    toggle = if $(this).data('delete-upload') is 1 then 0 else 1
    $(this).data('delete-upload', toggle)
    text = $(this).text()
    $(this).text($(this).data('swap-text'))
           .data('swap-text', text)
           .prev().toggleClass('strikeout')

  file_field_template = $('#new-uploads li:first').clone().detach()
  $('#new-uploads input').live 'change', ->
    $(this).hide().parent().append /[^\\\/]+$/.exec($(this).val())[0]
    file_field_template.clone().appendTo $('#new-uploads')
  
  $('#update-form').submit ->
    $('#new-uploads input:last').remove()
    true
    
  $('.comment-input').click ->
    par = $(this).parent()
    par.children('.comment-submit').show()
    par.blur ->
      $(this).children('.comment-submit').hide()