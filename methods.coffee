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
      upVotes: 0
      votes: 0

  favourite: (data) ->
    skill = Skills.findOne id: 'favourite'
    if !isAllowedToUseSkill skill
      return 0 
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
    skill = Skills.findOne id: 'comment'
    if !isAllowedToUseSkill skill
      return 0
   
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
      
      Collections[comment.topicType].update comment.topic,
        $set: lastComment: new Date().getTime()
        $inc: comments: 1

  vote: (data) ->
    skill = Skills.findOne id: 'vote'
    if !isAllowedToUseSkill skill
      return 0
    basic = Meteor.call 'basic'
    _.extend data, basic
    
    vote = Votes.findOne
      user: @userId
      entity: data.entity
    
    if vote
      Votes.update vote._id, $set: data

      if vote.up is true and data.up is false
        diff = -1
      else if vote.up is false and data.up is true
        diff = 1

      if diff
        Collections[vote.entityType].update vote.entity, 
          $set: lastVote: new Date().getTime()
          $inc: upVotes: diff

    else
      _.extend data,
        type: 'vote'
        upVotes: 0
        votes: 0

      id = Votes.insert data

      vote = Votes.findOne id
      target = Collections[vote.entityType].findOne vote.entity
      notify vote, target

      Collections[vote.entityType].update vote.entity, 
        $set: lastVote: new Date().getTime()
        $inc: 
          upVotes: if data.up then 1 else 0
          votes: 1

    calculateScore Collections[data.entityType], data.entity

  upload: (formData, accomplishId) ->
    if Meteor.isClient
      user = Meteor.user()
      url = "https://graph.facebook.com/#{user.services.facebook.id}/photos/"
      options =
        params:
          access_token: user.services.facebook.accessToken
        contentType: 'multipart/form-data'
        content: formData
      
      Meteor.http.post url, options, (error, result) ->
        unless error
          id = result.data.id
          Accomplishments.update accomplishId, 
            $set: 
              facebookImageId: id

  accomplish: (data, formData) ->
    delete data._id
    delete data.collection
    skill = Skills.findOne id: 'accomplish'

    if !isAllowedToUseSkill skill
      return 0

    acc = Accomplishments.findOne
      user: @userId
      entity: data.entity

    if acc
      acc.tags or (acc.tgags = [])
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

    #Meteor.call 'upload', formData, accomplishId
    return accomplishId
 
  newAchievement: (data) ->
    delete data._id
    delete data.collection

    basic = Meteor.call 'basic'
    _.extend data, basic
    data.type = 'achievement'
    time = new Date().getTime()

    # check if user is spamming
    skill = Skills.findOne id: 'newAchievement'
    if !isAllowedToUseSkill skill
      return 0

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

updateScore = (collection, id, score) ->
  collection.update id,
    $set:
      score: score.naive
      best: score.wilson
      hot: score.hot
      value: Math.round 10*score.wilson

# using the Pentagonal numbers (http://oeis.org/A000326) 
# starting at the 4th (12).
nextLevel = (level) ->
  n = level + 2
  return n*(3*n-1)/2

# calculates the sum of all previous levels
prevLevels = (level) ->
  prev = 0
  i = 0
  while i < level - 1
    i++
    prev += nextLevel i 
  return prev

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
  doc = collection.findOne id

  up = doc.upVotes
  down = doc.votes - doc.upVotes

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

# XXX: I'm too stupid to write this function. 
# please fix that LastChanged gets updated on every try, thanks.
isAllowedToUseSkill = (skill) ->
  user = Meteor.user()

  #if _.has(skill, 'level')
  #  unless user.level >= skill.level
  #    return false

  if _.has(skill, 'cooldown')
    time = new Date().getTime()
    isAllowed = true
    if _.has(user, skill.name+'LastChanged')
      if (user[skill.name+'LastChanged'] + skill.cooldown*1000) > time
        isAllowed = false
    setter = {}
    setter[skill.name+'LastChanged'] = time
    Meteor.users.update user._id, $set: setter
    return isAllowed
  else
    return true
