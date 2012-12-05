Meteor.methods
  restore: (targetState) ->
    entity = Collections[targetState.entityType].findOne targetState.entity
    entity.lastModifiedBy = @userId
    notify targetState, entity

    revisions = Revisions.find
      entity: targetState.entity
      date: $gte: targetState.date
    ,
      sort:
        date: -1

    revisions = revisions.fetch()
    _.each revisions, (revision) ->
      diff = revision.diff
      keys = _.keys diff

      entity = patch entity, diff, keys

    delete entity._id
    Collections[targetState.entityType].update targetState.entity, $set: entity

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
      user: @userId
      date: new Date().getTime()
      score: 0
      hot: 0
      best: 0
      value: 0
      comments: 0

  favourite: (data) ->
    fav = Favourites.findOne
      user: @userId
      entity: data.entity
    
    if fav
      Favourites.update fav._id,
        $set:
          active: !fav.active
    else
      Favourites.insert
        type: 'favourite'
        user: @userId
        entity: data.entity
        active: true

  suggestTitle: (data) ->
    basic = Meteor.call 'basic'
    _.extend data, basic,
      type: 'title'
    id = Titles.insert data

    title = Titles.findOne id
    achievement = Achievements.findOne title.entity
    notify title, achievement

    Meteor.call 'assignBestTitle', title

  comment: (data) ->
    comment = Comments.findOne data._id
    if comment and comment.user is @userId
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
      id = Comments.insert data

      comment = Comments.findOne id
      target = Collections[comment.topicType].findOne comment.topic
      notify comment, target
  
      if comment.parent?
        parent = Comments.findOne comment.parent
        notify comment, parent
  
      Collections[comment.topicType].update comment.topic, $inc: comments: 1

  vote: (data) ->
    basic = Meteor.call 'basic'
    _.extend data, basic
    
    vote = Votes.findOne
      user: @userId
      entity: data.entity
    
    if vote
      Votes.update vote._id, $set: data
    else
      data.type = 'vote'
      id = Votes.insert data

      vote = Votes.findOne id
      target = Collections[vote.entityType].findOne vote.entity
      notify vote, target

    calculateScore Collections[data.entityType], data.entity

  accomplish: (data) ->
    acc = Accomplishments.findOne
      user: @userId
      entity: data.entity

    if acc
      acc.tags or (acc.tags = [])
      data.tags or (data.tags = [])
      tags = _.union acc.tags, data.tags

      Accomplishments.update acc._id,
        $set:
          story: data.story
          tags: tags

      accomplishId = acc._id

    else
      basic = Meteor.call 'basic'
      _.extend data, basic

      data.type = 'accomplishment'
      accomplishId = Accomplishments.insert data

      # update user score
      achievement = Achievements.findOne data.entity
      Meteor.users.update @userId,
        $inc:
          score: achievement.value

      # send notificatións
      accomplishment = Accomplishments.findOne accomplishId
      notify accomplishment, achievement

    return accomplishId
 
  newAchievement: (data) ->
    basic = Meteor.call 'basic'
    _.extend data, basic
    data.type = 'achievement'
    delete data._id
    delete data.collection
    id = Achievements.insert data

    if data.title
      titleData =
        title: data.title
        entity: id

      Meteor.call 'suggestTitle', titleData

    return id 

  updateUserScoreComplete: ->
    unless @is_simulation
      a = Achievements.find
        $where: "
          return db.accomplishments.findOne({
            user: '#{@userId}',
            entity: this._id
          }) "
      ,
        fields:
          value: 1

      a = a.fetch()
      s = _.pluck a, 'value'
      score = _.reduce s, (memo, num) ->
        return memo + num
      , 0
      
      Meteor.users.update @userId,
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

notify = (entity, target) ->
  if entity and target
    receivers = [target.user]

    Notifications.insert
      date: new Date().getTime()
      type: 'notification'
      user: entity.user
      entity: entity._id
      entityType: entity.type
      target: target._id
      targetType: target.type
      receivers: receivers

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

patch = (entity, diff, keys) ->
  _.each keys, (key) ->
    if _.isArray entity[key]
      if diff[key].removed
        entity[key] = _.union entity[key], diff[key].removed
      if diff[key].added
        entity[key] = _.difference entity[key], diff[key].added

    else if _.isObject entity[key]
      throw new Error "#{key} is an Object, should recurse, but not implemented"

    else if diff[key]
      entity[key] = diff[key]

  return entity

