$('a[data-delete-upload]').live 'click', ->
  toggle = if $(this).data('delete-upload') is 1 then 0 else 1
  $(this).data('delete-upload', toggle)
  text = $(this).text()
  $(this).text($(this).data('swap-text'))
         .data('swap-text', text)
         .prev().toggleClass('strikeout')