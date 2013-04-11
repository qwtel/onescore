Template.ladder.events

rank = 1
Template.ladder.helpers
  users: ->
    console.log "ranking..."
    cursor = Meteor.users.find {},
      sort: 'profile.xp': -1

    rank = 1
    users = []
    cursor.forEach (user) ->
      _.extend user, rank: rank++
      users.push user
    return users
