#= require jquery
#= require jquery_ujs

$('body').bind 'ajax:error', (xhr, status, error) ->
  if status == 401
    window.location.href = '/login'

window.url =
  invitations:
    search: '/invitations/search.json'

