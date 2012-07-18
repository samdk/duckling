#= require application
#= require chosen.jquery.min

$ ->
  $('.toggle-update-form').click (e) ->
    $('#update-form').toggleClass 'hide'
    e.preventDefault()
    
  $('.chzn-select').chosen()
