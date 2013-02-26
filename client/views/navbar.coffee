Template.navbar.events
  'click .nav-spell': (e) ->
    if @click and @usable and @usable() then @click()

  'click #log-out': (e) ->
    Meteor.logout()
    Router.navigate '/home', true

Template.navbar.rendered = ->
  # XXX: Does this create a memory leak?
  $('.popover').remove()

  $(@findAll('.spell')).popover
    animation: false
    container: 'body'
    html: true
    placement: 'bottom'
    trigger: 'hover'

Template.navbar.helpers
  nav: ->
    user = Meteor.user()
    if user and user.profile
      Skills.find 
        nav: true
        level: $lte: user.profile.level

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
  
