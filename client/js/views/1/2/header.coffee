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
    items = [
        name: 'Home'
        icon: 'home'
      ,
        name: 'Explore'
        icon: 'road'
      ,
        name: 'Ladder'
        icon: 'globe'
      ,
        name: 'Profile'
        icon: 'user'
        url: Meteor.user().username
      ,
        name: 'Quest Log'
        icon: 'book'
        url: Meteor.user().username+'/questlog'
      ,
        name: 'New achievement'
        icon: 'certificate'
        url: 'achievements/new'
    ]

    for item in items
      unless item.url
        item.url = item.name.toLowerCase()

    return items

  numNotifications: ->
    if Meteor.user()
      Notifications.find(
        receivers: Meteor.user()._id
        seen: $ne: Meteor.user()._id
      ).count()
