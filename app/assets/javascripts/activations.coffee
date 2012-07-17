#= require application
#= require chosen.jquery.min

$ ->  
  scrollPos = 0
  origMargin = 0
  showNewUpdatePopup = () ->
    scrollPos = $('body').scrollTop()
    origMargin = $('#body').css('marginTop')
    $('#body').css position: 'fixed', marginTop: origMargin-scrollPos
    $('#new-update-form,#shield').show()
    
  hideNewUpdatePopup = () ->
    $('#new-update-form,#shield').hide()
    $('#body').css position: 'static', marginTop: origMargin
    $('body').scrollTop(scrollPos)
    
  $('.close-popups').click ->
    hideNewUpdatePopup()
    false

  $('.toggle-update-form').click (e) ->
    $('#update-form').toggleClass 'hide'
    e.preventDefaultAction()
    
  $('.chzn-select').chosen()
