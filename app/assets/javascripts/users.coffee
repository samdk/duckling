$ ->
  $('#add-email-address-field').click ->
    p = $(this).parent().prev()
    p.clone().insertAfter(p).children(':first').val('')
    false