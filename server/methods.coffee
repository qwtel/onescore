table = {}
Meteor.startup ->
  # HACK: is there a better way?
  table =
    titles: Titles
    achievements: Achievements
    accomplishments: Accomplishments
    comments: Comments

  # fetch facebook data when a new user is added
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

  # trustworthy dates..
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
  Votes.find(
    entity: id
    up: up
  ).count()

calculateScore = (id) ->
  up = countVotes id, true
  down = countVotes id, false

  ## max score for an achievement should be 10
  #Math.round 10*wilson

  score =
    naive: naiveScore up, down
    wilson: wilsonScore up, up+down
    hote: hotScore up, down, Date()

naiveScore = (up, down) ->
  return up - down

wilsonScore = (pos, n) ->
  if n is 0
    return 0

  # NOTE: hardcoded for performance (confidence = 0.95)
  z = 1.96
  phat = pos/n

  (phat + z*z/(2*n) - z * Math.sqrt((phat*(1-phat)+z*z/(4*n))/n))/(1+z*z/n)

hotScore = (up, down, date) ->
  s = naiveScore(up, down)
  #order = Math.log(Math.max(Math.abs(s), 1), 10)
  #sign = 1 if s > 0 else -1 if s < 0 else 0
  return 3

updateScore = (collection, id, score, callback) ->
  collection.update id,
    $set:
      score: score.naive
      best: score.wilson
      hot: score.hot
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
