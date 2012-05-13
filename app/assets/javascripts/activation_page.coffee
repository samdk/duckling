#= require application

boundPaneObjs = []

$ ->
  $('#invite-link a').click((e) ->
    e.preventDefault()
    showPane('invite'))
  showPane('invite')
  $('#panel .close-button').click((e) ->
    console.log('closed')
    e.preventDefault()
    hidePane())

showPane = (kind) ->
  $('#panel .panel').hide()
  $('#panel').show()

  switch kind
    when "invite" then showInvitePanel()
    else throw "no such pane #{kind}"

hidePane = ->
  $('#panel').hide()
  $('#panel .panel').hide()
  obj.unbind() for obj in boundPaneObjs
  boundPaneObjs = []

invitePanel = (extra) ->
  if extra == undefined
    $("#invite.panel")
  else
    $("#invite.panel #{extra}")

showInvitePanel = ->
  invitePanel().show()
  input = invitePanel('input')
  boundPaneObjs.push(input)
  input.keyup(->
    filterUsers(input.val()))

filterUsers = (filterStr) ->
  if filterStr == ""
    invitePanel('.invitee').show()
  else
    filter = RegExp(filterStr.toLowerCase())
    invitePanel('.users').children('li').each((idx,invitee) ->
      invitee = $(invitee)
      text = invitee.children('.search-text').first().text().toLowerCase()
      if filter.test(text) or invitee.children('input:checked').length > 0
        invitee.show()
      else
        invitee.hide())

