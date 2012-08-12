table = {}
Meteor.startup ->
  # HACK: Is there a better way?
  table =
    titles: Titles
    achievements: Achievements
    accomplishments: Accomplishments
    comments: Comments

  Meteor.users.find().observe
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

  Achievements.find().observe
    added: (achievement) ->
      Achievements.update achievement._id,
        $set:
          date: new Date()

  Comments.find().observe
    added: (comment) ->
      Comments.update comment._id,
        $set:
          date: new Date()

countVotes = (id, up) ->
  return Votes.find(
    entity: id
    up: up
  ).count()

# TODO: Better score formula...
calculateScore = (id) ->
  up = countVotes id, true
  down = countVotes id, false
  return up - down

updateScore = (collection, id, score, callback) ->
  collection.update id,
    $set:
      score: score
    ,
      callback

Meteor.methods
  vote: (collection, entity, up) ->
    data =
      user: @userId()
      entity: entity
      collection: collection
      date: new Date()
      up: up
    
    vote = Votes.findOne
      user: @userId()
      entity: entity
    
    if vote
      Votes.update vote._id,
        $set: data
    else
      Votes.insert data

    # HACK: update achievement title
    if collection is 'titles'
      callback = ->
        # HACK: I can't even begin to explain this...
        achievement = Titles.findOne(entity).entity
        best = Titles.findOne
          entity: achievement
        ,
          sort:
            score: -1

        if best
          Achievements.update achievement,
            $set:
              title: best.title

    score = calculateScore entity
    updateScore table[collection], entity, score, callback

  accomplish: (id, stry) ->
    acc = Accomplishments.findOne
      user: @userId()
      entity: id

    if acc
      Accomplishments.update acc._id,
        $set:
          story: stry
          update: new Date()
    else
      Accomplishments.insert
        user: @userId()
        entity: id
        story: stry
        score: 0
        date: new Date()

      a = Achievements.findOne id
      if a
        Meteor.users.update @userId(),
          $inc:
            score: a.score

  # HACK: this will cause problems at num achievements > some constant
  updateUserScoreComplete: ->
    accs = Accomplishments.find
      user: @userId()

    accs = accs.fetch()
    entities = _.pluck accs, 'entity'

    a = Achievements.find
      _id: $in: entities

    a = a.fetch()
    s = _.pluck a, 'score'
    score = _.reduce s, (memo, num) ->
      return memo + num
    , 0
    updateScore Meteor.users, @userId(), score
