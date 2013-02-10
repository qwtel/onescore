_.extend Template.header,
  events: ->
    'click .category .nav-item': (e) ->
      $t = $(e.target).closest '.category'
      category = $t.data 'category'
      Session.set 'category', category

  rendered: ->
    # XXX: Does this create a memory leak?
    $('.popover').remove()

    $('.spell').popover
      placement: 'bottom'
      trigger: 'hover'

  pic: ->
    user = Meteor.user()
    if user
      if user.services
        fbid = _.escape user.services.facebook.id
        return "<img src='https://graph.facebook.com/#{fbid}/picture'/>"

  items: ->
    if Meteor.user()
      user = Meteor.user()
      Skills.find level: $lte: user.level

  cooldownText: ->
    if @cooldown?
      if @cooldown == 1
        return '1 second cooldown'
      else
        return "#{@cooldown} seconds cooldown"
    else
      return '' 

  isPassive: ->
    return if @passive then 'passive' else ''

  numNotifications: ->
    if Meteor.user()
      user = Meteor.user()._id
      Notifications.find(
        user: $ne: user
        receivers: user
        seen: $ne: user
      ).count()
