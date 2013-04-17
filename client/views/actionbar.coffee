Template.actionbar.events
  'click .spell': (e) ->
    page = Session.get 'page'
    id = Session.get "#{page}/target"
    type = Session.get "#{page}/type"
    if @click and @usable and @usable(id, type) then @click(id, type)

Template.actionbar.rendered = ->
  # XXX: Does this create a memory leak?
  $('.popover').remove()

  $(@findAll('.spell')).popover
    animation: false
    container: 'body'
    html: true
    placement: 'top'
    trigger: 'hover'

Template.actionbar.helpers
  sid: ->
    page = Session.get 'page'
    Session.get "#{page}/target"

  stype: ->
    page = Session.get 'page'
    Session.get "#{page}/type"

  active: (id) ->
    if @active id then 'active' else ''

  usable: ->
    page = Session.get 'page'
    id = Session.get "#{page}/target"
    type = Session.get "#{page}/type"
    @usable(id, type)

  skills: ->
    user = Meteor.user()
    if user and user.profile
      Skills.find 
        nav: $ne: true
        level: $lte: user.profile.level

  cooldownText: ->
    if @cooldown?
      if @cooldown == 1
        return '1 second cooldown'
      else
        return "#{@cooldown} seconds cooldown"
    else
      return '' 
