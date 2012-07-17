#= require application
#= require chosen.jquery.min

$ ->
  activation_id = $("#activation-select").data('activation_id')
  
  pollForUpdates = () ->
    $.getJSON '/activations.json', (data) ->
      e = $("#activation-picker ol")
      last = e.children(':last').detach()
      e.empty().append(last)
      for activation in data
        a = activation.activation
        if a.id != activation_id
          e.prepend "<li><a href=\"/activations/#{a.id}\">#{a.title}</a></li>"
  
  pollForUpdates()
  # setInterval pollForUpdates, 1000
  
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

  $('.toggle-update-form').click -> $('#update-form').toggleClass 'hide'
    
  $('.chzn-select').chosen()
