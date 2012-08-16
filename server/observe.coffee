Meteor.startup ->
  # Assign global ranks
  users = Meteor.users.find {},
    sort: score: -1

  rank = 1
  users.forEach (user) ->
    Meteor.users.update user._id,
      $set:
        rank: rank
    rank++

  # fetch facebook data when a new user is added
  users.observe
    added: (user) ->
      url = "https://graph.facebook.com/#{user.services.facebook.id}"
      options =
        params:
          access_token: user.services.facebook.accessToken
  
      Meteor.http.get url, options, (error, res) =>
        Meteor.users.update user._id,
          $set:
            username: res.data.username
            bio: res.data.bio
            location: res.data.location.name

    moved: (user, oldRank, newRank) ->
      Meteor.users.update user._id,
        $set:
          rank: newRank

  Titles.find().observe
    changed: (title) ->
      achievementId = title.entity
      best = Titles.findOne
        entity: achievementId
      ,
        sort:
          score: -1

      if best
        Achievements.update achievementId,
          $set:
            title: best.title
