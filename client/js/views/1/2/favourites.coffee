_.extend Template.favourites,
  favourites: ->
    sort = Template.filter.sort()

    username = Session.get 'username'
    if username
      user =  Meteor.users.findOne
        username: username

      if user
        return Favourites.find
          user: user._id
          active: true
        ,
          sort: sort

  achievement: ->
    sel = {}
    sel._id = @entity

    if Session.get('category')?
      sel.category = Session.get 'category'

    return Achievements.findOne sel
