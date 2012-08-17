_.extend Template.accomplishments,
  accomplishments: ->
    sort = Template.filter.sort()

    username = Session.get 'username'
    if username
      user =  Meteor.users.findOne
        username: username

      if user
        return Accomplishments.find
          user: user._id
        ,
          sort: sort
