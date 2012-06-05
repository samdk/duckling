#= require application

boundPaneObjs = []

class Invitable
  constructor: (elem) ->
    elem = $(elem)
    @targetClass = elem.data('target-class')
    @targetId    = elem.data('target-id')
    if @targetClass == undefined or @targetId == undefined
      raise "invitation links must define the properties data-target-class and data-target-id"
  data: -> { target_class: @targetClass, target_id: @targetId }

$ ->
  inviteLink().click((e) ->
    inv = new Invitable(e.currentTarget)
    e.preventDefault()
    showPane('invite',inv))
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

selectorExtension = (usual) ->
  (extra) -> if extra == undefined then $(usual) else $("#{usual} #{extra}")

# invitations panel + stuff
inviteLink  = selectorExtension('a.invite-link')
invitePanel = selectorExtension('#invite.panel')

loadThingsToInvite = (f) ->
  params =
    target_class: inviteLink().data('target-class')
    target_id:    inviteLink().data('target-id')
  console.log params
  $.post(window.url.invitations.search,params,f)

showInvitePanel = ->
  invitePanel().show()
  loadThingsToInvite((response) ->
    input = invitePanel('input')
    boundPaneObjs.push(input)
    input
  
    input.keyup(-> filterUsers(input.val()))
    )



filterUsers = (filterStr) ->
  if filterStr == ""
    invitePanel('.invitee').show()
  else
    filter = RegExp(filterStr.toLowerCase())
    invitePanel('.users').children('li').each((idx,invitee) ->
      invitee = $(invitee)
      text = invitee.data('search-text').toLowerCase()
      if filter.test(text) or invitee.children('input:checked').length > 0
        invitee.show()
      else
        invitee.hide())

