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

        test = Accomplishments.find sel

        sort = Template.filter.sort()
        accomplishments = Accomplishments.find sel,
          sort: sort
          limit: 3*(Session.get('skip')+1)

        if test.count() is 0 then false else accomplishments
