_.extend Template.favourites,
  select: ->
    sel = {}
    sel.created = true

    if Session.get('category')?
      sel.category = Session.get 'category'

    return sel

  favourites: ->
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
        return Favourites.find
          user: user._id
          active: true
        ,
          sort: data

  achievement: ->
    sel = {}
    sel._id = @entity

    if Session.get('category')?
      sel.category = Session.get 'category'

    if Session.equals 'menu', 'questlog'
      acc = Accomplishments.findOne
        user: Meteor.user()._id
        entity: @entity
      if acc
        return false

    return Achievements.findOne sel

  achievements: ->
    sel = Template.achievements.select()
    sort = Session.get 'sort'

    switch sort
      when 'hot' then data = hot: -1
      when 'cool' then data = hot: 1

      when 'new' then data = date: -1
      when 'old' then data = date: 1

      when 'best' then data = best: -1
      when 'worst' then data = best: 1

    a = Achievements.find sel,
      sort: data
    return a
