#= require application
#= require activations
#= require comments

$ ->
  $('.comment-input').click ->
    par = $(this).parent()
    par.children('.comment-submit').show()
    par.blur ->
      $(this).children('.comment-submit').hide()
