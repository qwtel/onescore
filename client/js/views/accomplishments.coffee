_.extend Template.accomplishments,
  accomplishments: ->
    sort = Session.get 'sort'

    switch sort
      when 'hot' then data = hot: -1
      when 'cool' then data = hot: 1

      when 'new' then data = date: -1
      when 'old' then data = date: 1

      when 'best' then data = best: -1
      when 'worst' then data = best: 1

    username = Session.get 'username'
    if username
      user =  Meteor.users.findOne
        username: username

      if user
        return Accomplishments.find
          user: user._id
        ,
          sort: data
