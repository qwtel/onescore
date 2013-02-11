_.extend Template.achievers,
  accomplishments: ->
    username = Session.get 'username'
    if username
      user = Meteor.users.findOne
        username: username

      if user
        sel = Template.accomplishments.select()
        _.extend sel,
          user: user._id
          entity: @_id

        sort = Template.filter.sort()
        return Accomplishments.find sel,
          sort: sort
          limit: 3*(Session.get('skip')+1)
