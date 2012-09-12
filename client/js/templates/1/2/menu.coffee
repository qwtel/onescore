_.extend Template.menu,
  user: ->
    username = Session.get 'username'
    if username
      return Meteor.users.findOne
        username: username

