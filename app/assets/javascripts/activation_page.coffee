#= require application

boundPaneObjs = []

$ ->
  inviteLink().click (e) ->
    e.preventDefault()
    showPane('invite')
  # showPane('invite') # uncomment to always show for testing
  $('#panel .close-button').click (e) ->
    e.preventDefault()
    hidePane()    

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

selectorExtension = (usual) ->
  (extra) -> if extra == undefined then $(usual) else $("#{usual} #{extra}")

# invitations panel + stuff
inviteLink  = selectorExtension('a.invite-link')
invitePanel = selectorExtension('#invite.panel')

loadThingsToInvite = (f) ->
  params =
    target_class: inviteLink().data('target-class')
    target_id:    inviteLink().data('target-id')
  $.post(window.url.invitations.search,params,f)

showInvitePanel = ->
  invitePanel().show()
  loadThingsToInvite (response) ->
    input = invitePanel('input[type="text"]')
    boundPaneObjs.push(input)
    input.keyup () -> filterUsers(input.val())

filterUsers = (filterStr) ->
  if filterStr == ""
    invitePanel('.invitee').show()
  else
    filter = RegExp(filterStr.toLowerCase())
    invitePanel('.users').children('li').each (idx,invitee) ->
      invitee = $(invitee)
      text = invitee.data('search-text').toLowerCase()
      if filter.test(text) or invitee.children('input:checked').length > 0
        invitee.show()
      else
        invitee.hide()

