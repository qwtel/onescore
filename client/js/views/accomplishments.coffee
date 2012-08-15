_.extend Template.accomplishments,
  accomplishments: ->
    sort = Session.get 'sort'

    switch sort
      when 'hot' then data = score: -1
      when 'cool' then data = score: 1

      when 'new' then data = date: -1
      when 'old' then data = date: 1

      when 'best' then data = score: -1
      when 'wort' then data = score: 1

    username = Session.get 'username'
    if username
      user =  Meteor.users.findOne
        username: username

      if user
        return Accomplishments.find
          user: user._id
        ,
          sort: data
