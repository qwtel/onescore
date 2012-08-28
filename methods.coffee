Meteor.methods
  assignBestTitle: (title) ->
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

  basic: ->
    data =
      user: @userId()
      date: new Date()
      score: 0
      hot: 0
      best: 0
      value: 0
      comments: 0

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

        data.type = 'achievement'
        id = Achievements.insert data

      return id

  comment: (data) ->
    comment = Comments.findOne data._id
    if comment and comment.user is @userId()
      Comments.update data._id,
        $set: text: data.text

    else
      basic = Meteor.call 'basic'
      _.extend data, basic,
        entity: data.topic
        entityType: data.topicType

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
      
      data.type = 'comment'
      Comments.insert data

  vote: (data) ->
    basic = Meteor.call 'basic'
    _.extend data, basic
    
    vote = Votes.findOne
      user: @userId()
      entity: data.entity
    
    if vote
      Votes.update vote._id,
        $set: data
    else
      data.type = 'vote'
      Votes.insert data

    calculateScore Collections[data.entityType], data.entity

  accomplish: (data) ->
    acc = Accomplishments.findOne
      user: @userId()
      entity: data.entity

    if acc
      Accomplishments.update acc._id,
        $set:
          story: data.story
          tags: data.tags

      accomplishId = acc._id
    else
      basic = Meteor.call 'basic'
      _.extend data, basic

      data.type = 'accomplishment'
      accomplishId = Accomplishments.insert data

      achievement = Achievements.findOne data.entity
      if achievement
        Meteor.users.update @userId(),
          $inc:
            score: achievement.value

    return accomplishId
 
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
    score = _.reduce s, (memo, num) ->
      return memo + num
    , 0

    Meteor.users.update @userId(),
      $set:
        score: score

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

