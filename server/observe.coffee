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

  users.observe
    # fetch facebook data when a new user is added
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

    # keep ladder rank up to date
    moved: (user, oldRank, newRank) ->
      Meteor.users.update user._id,
        $set:
          rank: newRank

  # assing 'best' title to its achievement
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

  ###
  Titles.find().observe
    added: (entity) ->
      Titles.update entity._id,
        $set:
          type: 'title'

  Achievements.find().observe
    added: (entity) ->
      Achievements.update entity._id,
        $set:
          type: 'achievement'

  Accomplishments.find().observe
    added: (entity) ->
      Accomplishments.update entity._id,
        $set:
          type: 'accomplishment'

  Votes.find().observe
    added: (entity) ->
      Votes.update entity._id,
        $set:
          type: 'vote'

  Comments.find().observe
    added: (entity) ->
      Comments.update entity._id,
        $set:
          type: 'comment'
  ###
