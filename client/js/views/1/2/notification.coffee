_.extend Template.notification,
  user: ->
    Meteor.users.findOne @user
