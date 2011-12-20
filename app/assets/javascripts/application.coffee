#= require jquery
#= require jquery_ujs
#= require_self
#= require_tree .

$('body').bind 'ajax:error', (xhr, status, error) ->
  if status == 401
    window.location.href = '/login'