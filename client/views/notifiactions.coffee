Template.notifications.helpers
  notifications: ->
    userId = Meteor.userId()
    if userId
      limit = Session.get('limit') or 1

      sel = 
        receivers: userId
        #user: $ne: userId

      Notifications.find sel,
        sort: date: -1
        limit: 25 * limit

  hasMore: ->
    userId = Meteor.userId()
    query = Notifications.find 
      receivers: userId
      #user: $ne: userId
    count = query.count()
    limit = Session.get("limit") or 1
    return 25 * limit < count

Template.notifications.destroyed = ->
  Meteor.call 'notifyy'

