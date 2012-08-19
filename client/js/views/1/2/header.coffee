_.extend Template.header,
  events:
    'click .category .nav-item': (e) ->
      $t = $(e.target).closest '.category'
      category = $t.data 'category'
      Session.set 'category', category

  pic: ->
    user = Meteor.user()
    if user
      if user.services
        fbid = _.escape user.services.facebook.id
        return "<img src='https://graph.facebook.com/#{fbid}/picture'/>"

  items: ->
    for item in window.items
      unless item.url
        item.url = item.name.toLowerCase()
    return window.items

  numNotifications: ->
    if Meteor.user()
      Notifications.find(
        receivers: Meteor.user()._id
        seen: $ne: Meteor.user()._id
      ).count()
