$ ->
  $('#add-email-address-field').click (event)->
    console.log 'Firing'
    # ul = $('#email-addresses')
    # ul.children(':first').clone().appendTo(ul).children(':first').val('')
    event.stopPropagation()