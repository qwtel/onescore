table = {}
Meteor.startup ->
  # HACK: is there a better way?
  table =
    titles: Titles
    achievements: Achievements
    accomplishments: Accomplishments
    comments: Comments

Meteor.methods
  basic: ->
    data =
      user: @userId()
      date: new Date()
      score: 0
      hot: 0
      best: 0

  newAchievement: ->
    unless @is_simulation
      newAchievement = Achievements.findOne
        user: @userId()
        created: false

      if newAchievement
        id = newAchievement._id
      else
        data = Meteor.call 'basic'
        _.extend data,
          created: false

        id = Achievements.insert data

      return id

  comment: (data) ->
    comment = Comments.findOne data._id
    if comment and comment.user is @userId()
      Comments.update data._id,
        $set: text: data.text

    else
      basic = Meteor.call 'basic'
      _.extend data, basic

      parent = Comments.findOne data.parent
      if parent
        _.extend data,
          parent: parent._id
          mention: parent.user
          level: parent.level + 1
      else
        _.extend data,
          parent: null
          mention: null
          level: 0
      
      Comments.insert data

  vote: (collection, entity, up) ->
    data =
      entity: entity
      collection: collection
      up: up

    basic = Meteor.call 'basic'
    _.extend data, basic
    
    vote = Votes.findOne
      user: @userId()
      entity: entity
    
    if vote
      Votes.update vote._id,
        $set: data
    else
      Votes.insert data

    calculateScore table[collection], entity

  accomplish: (id, stry) ->
    acc = Accomplishments.findOne
      user: @userId()
      entity: id

    if acc
      Accomplishments.update acc._id,
        $set:
          story: stry
      id = acc._id
    else
      data =
        entity: id
        story: stry

      basic = Meteor.call 'basic'
      _.extend data, basic

      id =Accomplishments.insert data

      a = Achievements.findOne id
      if a
        Meteor.users.update @userId(),
          $inc:
            score: a.value

    return id

  # HACK: this will cause problems at num achievements > some constant
  updateUserScoreComplete: ->
    accs = Accomplishments.find
      user: @userId()

    accs = accs.fetch()
    entities = _.pluck accs, 'entity'

    a = Achievements.find
      _id: $in: entities

    a = a.fetch()
    s = _.pluck a, 'value'
    score = {}
    score.naive = _.reduce s, (memo, num) ->
      return memo + num
    , 0

    updateScore Meteor.users, @userId(), score

countVotes = (id, up) ->
  Votes.find(
    entity: id
    up: up
  ).count()

updateScore = (collection, id, score) ->
  collection.update id,
    $set:
      score: score.naive
      best: score.wilson
      hot: score.hot
      value: Math.round 10*score.wilson

calculateScore = (collection, id) ->
  up = countVotes id, true
  down = countVotes id, false

  doc = collection.findOne id

  score =
    naive: naiveScore up, down
    wilson: wilsonScore up, up+down
    hot: hotScore up, down, doc.date

  updateScore collection, id, score

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
  a = new Date(date).getTime()
  b = new Date(2005, 12, 8, 7, 46, 43).getTime()
  ts = a - b

  x = naiveScore up, down

  if x > 0 then y = 1
  else if x < 0 then y = -1
  else y = 0

  z = Math.max(Math.abs(x), 1)

  Math.round(Math.log(z)/Math.log(10) + y*ts/45000)

