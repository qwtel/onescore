_.extend Template.notifications,
  notifications: ->
    ret = Notifications.find
      receivers: Meteor.user()._id
      user: $ne: Meteor.user()._id
    ,
      sort: date: -1
      limit: 15*(Session.get('skip')+1)

    Notifications.update
      receivers: Meteor.user()._id
      seen: $ne: Meteor.user()._id
    ,
      $push:
        seen: Meteor.user()._id
    ,
      multi: true

    return ret
