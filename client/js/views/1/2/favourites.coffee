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
          $where: ->
            not Accomplishments.findOne
              user: user._id
              entity: @entity
        ,
          sort: sort

  achievement: ->
    Achievements.findOne @entity
