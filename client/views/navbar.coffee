Template.navbar.events
  'click .nav-spell': (e) ->
    if @click and @usable and @usable() then @click()

Template.navbar.rendered = ->
  # XXX: Does this create a memory leak?
  $('.popover').remove()

  $(@findAll('.spell')).popover
    placement: 'bottom'
    trigger: 'hover'
    animation: false

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
  