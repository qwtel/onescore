_.extend Template.userWidget,
  user: ->
    return Meteor.users.findOne Session.get('user')
