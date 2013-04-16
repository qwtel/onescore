Template.navbar.events
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
      return Skills.find 
        _id: $ne: 'newAchievement'
        nav: true
        level: $lte: user.profile.level
    else
      s = []
      s.push Skills.findOne('home')
      s.push Skills.findOne('explore')
      return s


  skills: ->
    user = Meteor.user()
    if user and user.profile
      Skills.find 
        nav: $ne: true
        level: $lte: user.profile.level

  cooldownText: ->
    if @cooldown?
      if @cooldown == 1
        return strings 'oneseccooldown'
      else
        return @cooldown + ' ' + strings('xseccooldown')
    else
      return '' 
  
  numNotifications: ->
    userId = Meteor.userId()
    if userId
      Notifications.find(
        user: $ne: userId
        receivers: userId
        seen: $ne: userId
      ).count()
