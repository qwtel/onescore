Template.notification.helpers
  user: ->
    Meteor.users.findOne @user

  targetUser: ->
    Meteor.users.findOne @targetUser

  type: (type, name) ->
    type is name
