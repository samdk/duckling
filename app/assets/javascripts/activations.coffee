#= require application
#= require chosen.jquery.min

$ ->
  $('.toggle-update-form').click (e) ->
    $('#update-form').toggleClass 'hide'
    e.preventDefaultAction()
    
  $('.chzn-select').chosen()
