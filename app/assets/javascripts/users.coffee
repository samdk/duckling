#= require application

$ ->
  $('#add-email-address-field').click (event) ->
    ul = $('#email-addresses')
    ul.children(':first').clone().appendTo(ul).children(':first').val('')
    event.stopPropagation()