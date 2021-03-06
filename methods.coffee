root = exports ? this
Meteor.methods
  newAchievement: (title, description, parentId, imgur) ->
    #if title? and title.length > 50 
    #  throw new Meteor.Error 500, "Title too long"
    #if description? and description.length > 140 
    #  throw new Meteor.Error 500, "Text too long"

    user = Meteor.user()
    skill = Skills.findOne 'newAchievement'
    unless isAllowedToUseSkill user, skill
      throw new Meteor.Error 500, "User not allowed to use skill"

    achievement = _.extend basic(),
      type: 'achievement'
      title: title
      description: description
      parent: parentId
      imgur: imgur
      favourites: 0
      accomplishments: 0

    # achievements have levels based on the number of predecessors
    achievement.level = 1
    if parentId?
      parent = Achievements.findOne parentId
      achievement.level = parent.level + 1

    achievement._id = Achievements.insert achievement

    #if data.title
    #  titleData =
    #    title: data.title
    #    entity: id
    #
    #  Meteor.call 'suggestTitle', titleData

    return achievement._id 

  favourite: (id) ->
    user = Meteor.user()
    skill = Skills.findOne 'favourite'
    unless isAllowedToUseSkill user, skill
      throw new Meteor.Error 500, "User not allowed to use skill"

    fav = Favourites.findOne
      user: user._id
      entity: id
    
    if fav
      Favourites.update fav._id,
        $set:
          active: !fav.active

      Achievements.update id,
        $inc:
          favourites: if !fav.active then 1 else -1

    else
      fav = _.extend basic(),
        type: 'favourite'
        entity: id
        active: true

      fav._id = Favourites.insert fav
      achievement = Achievements.findOne id
      notify skill, fav, achievement

      Achievements.update id,
        $inc:
          favourites: 1

  setStory: (id, story) ->
    #if story? and story.length > 10000 
    #  throw new Meteor.Error 500, "Text too long"

    user = Meteor.user()
    skill = Skills.findOne 'accomplish'
    unless isAllowedToUseSkill user, skill 
      throw new Meteor.Error 500, "User not allowed to use skill"

    acc = Accomplishments.findOne
      user: user._id
      entity: id

    if acc? 
      if story? and story isnt acc.story
        Accomplishments.update acc._id, $set: story: story
        return acc._id 

  accomplish: (id) ->
    user = Meteor.user()
    skill = Skills.findOne 'accomplish'
    unless isAllowedToUseSkill user, skill 
      throw new Meteor.Error 500, "User not allowed to use skill"

    voteFor user, id, 'achievement', true, Skills.findOne('voteUp')

    acc = Accomplishments.findOne
      user: user._id
      entity: id

    if acc? 
      Accomplishments.update acc._id, $set: active: !acc.active

      Achievements.update id,
        $inc:
          accomplishments: if !acc.active then 1 else -1

      return !acc.active

    else
      data = _.extend basic(),
        entity: id
        type: 'accomplishment'
        active: true

      data._id = Accomplishments.insert data

      Achievements.update data.entity,
        $inc:
          accomplishments: 1

      # notify
      achievement = Achievements.findOne data.entity
      notify skill, data, achievement

      # update user xp
      achievement = Achievements.findOne data.entity
      Meteor.users.update user._id,
        $inc:
          'profile.xp': achievement.value

      # level up?
      next = nextLevel user.profile.level
      inLevelXp = (user.profile.xp + achievement.value) -
        prevLevels(user.profile.level) 

      if inLevelXp >= next
        Meteor.users.update user._id,
          $inc:
            'profile.level': 1

      return data._id

  voteUp: (id, type) ->
    user = Meteor.user()
    skill = Skills.findOne 'voteUp'
    unless isAllowedToUseSkill user, skill
      throw new Meteor.Error 500, "User not allowd to use skill"
    voteFor user, id, type, true, skill

  voteDown: (id, type) ->
    user = Meteor.user()
    skill = Skills.findOne 'voteDown'
    unless isAllowedToUseSkill user, skill
      throw new Meteor.Error 500, "User not allowed to use skill"
    voteFor user, id, type, false, skill

  notifyy: ->
    sel = 
      receivers: @userId
      seen: $ne: @userId

    Notifications.update sel,
      $push:
        seen: @userId
    ,
      multi: true
      
  comment: (id, type, text) ->
    #if text? and text.length > 10000 
    #  throw new Meteor.Error 500, "Text too long"

    user = Meteor.user()
    skill = Skills.findOne 'comment'
    unless isAllowedToUseSkill user, skill
      throw new Meteor.Error 500, "User not allowed to use skill"
   
    comment = _.extend basic(),
      type: 'comment'
      entity: id
      entityType: type
      text: text

    if type is 'comment'
      parent = Comments.findOne id
      _.extend comment,
        parent: parent._id
        level: parent.level + 1
    else
      _.extend comment,
        parent: null
        level: 1
    
    comment._id = Comments.insert comment

    Collections[type].update id,
      $inc: comments: 1

    target = Collections[type].findOne id
    receivers = [target.user]

    node = comment
    while node.parent?
      node = Comments.findOne node.parent
      Collections[node.entityType].update node.entity,
        $inc: comments: 1

      entity = Collections[node.entityType].findOne node.entity
      receivers.push entity.user

    notify skill, comment, target, receivers

    #comment = Comments.findOne id
    #target = Collections[comment.topicType].findOne comment.topic
    #notify comment, target
    #
    #if comment.parent?
    #  parent = Comments.findOne comment.parent
    #  notify comment, parent

  saveImage: (id, result) ->
    Accomplishments.update
      entity: id
      user: @userId
    ,
      $set: 
        imgur: result.data.data
        source: result.data.data.link

  updateUserScore: ->
    unless @isSimulation
      a = Achievements.find
        $where: "
          return db.accomplishments.findOne({
            user: '#{@userId}',
            entity: this._id,
            active: true
          })"
      ,
        fields:
          value: 1

      score = 0
      a.forEach (achievement) ->
        score += achievement.value

      Meteor.users.update @userId,
        $set:
          'profile.xp': score

  deleteUnlock: (id) ->
    user = Meteor.user()
    skill = Skills.findOne 'delete'
    unless isAllowedToUseSkill user, skill 
      throw new Meteor.Error 500, "User not allowed to use skill"
    
    acc = Accomplishments.findOne
      _id: id
      user: user._id

    if acc? 
      Accomplishments.update id, 
        $set: 
          story: ''
          imgur: null
          active: false

      Achievements.update acc.entity,
        $inc:
          accomplishments: -1

  deleteAchievement: (id) ->
    user = Meteor.user()
    skill = Skills.findOne 'delete'
    unless isAllowedToUseSkill user, skill 
      throw new Meteor.Error 500, "User not allowed to use skill"
    
    a = Achievements.findOne
      _id: id
      user: user._id

    if a? 
      Achievements.update id, 
        $set: 
          active: false

  deleteComment: (id) ->
    user = Meteor.user()
    skill = Skills.findOne 'delete'
    unless isAllowedToUseSkill user, skill 
      throw new Meteor.Error 500, "User not allowed to use skill"
    
    c = Comments.findOne
      _id: id
      user: user._id

    if c? 
      Comments.update id, 
        $set: 
          text: ''
          active: false

  editComment: (id, text) ->
    user = Meteor.user()
    skill = Skills.findOne 'edit'
    unless isAllowedToUseSkill user, skill 
      throw new Meteor.Error 500, "User not allowed to use skill"
    
    c = Comments.findOne
      _id: id
      user: user._id

    if c? 
      Comments.update id, 
        $set: 
          text: text

voteFor = (user, id, type, active, skill) ->
  data = _.extend basic(),
    entity: id
    entityType: type
    active: active

  vote = Votes.findOne
    user: user._id
    entity: data.entity
  
  if vote
    Votes.update vote._id, $set: data

    if vote.active is true and active is false
      diff = -1
    else if vote.active is false and active is true
      diff = 1

    if diff
      Collections[vote.entityType].update vote.entity, 
        $inc: upVotes: diff

  else
    _.extend data,
      type: 'vote'
      upVotes: 0
      votes: 0

    id = Votes.insert data

    vote = Votes.findOne id
    target = Collections[vote.entityType].findOne vote.entity
    notify skill, vote, target
    
    Collections[vote.entityType].update vote.entity, 
      $inc: 
        upVotes: if data.active then 1 else 0
        votes: 1

  calculateScore Collections[data.entityType], data.entity

# using the Pentagonal numbers (http://oeis.org/A000326) 
# starting at the 4th (12).
root.nextLevel = (level) ->
  n = level + 2
  return n*(3*n-1)/2

# calculates the sum of all previous levels
root.prevLevels = (level) ->
  prev = 0
  i = 0
  while i < level - 1
    i++
    prev += nextLevel i 
  return prev

isAllowedToUseSkill = (user, skill) ->
  if _.has(skill, 'level')
    unless user.profile.level >= skill.level
      return false

  if _.has(skill, 'cooldown')
    time = new Date().getTime()
    isAllowed = true
    if _.has(user.profile, skill._id+'LastChanged')
      if (user.profile[skill._id+'LastChanged'] + skill.cooldown*1000) > time
        isAllowed = false

    if isAllowed
      setter = {}
      setter.profile = user.profile
      setter.profile[skill._id+'LastChanged'] = time 

      Meteor.users.update user._id, $set: setter
      return isAllowed
  else
    return true

# XXX: Shouldn't there be some kind of base model class that implements this?
basic = ->
  user: Meteor.user()._id
  date: new Date().getTime() # XXX Causes "double post" effect
  score: 0
  hot: 0
  best: 0
  value: 0
  comments: 0
  upVotes: 0
  votes: 0

calculateScore = (collection, id) ->
  doc = collection.findOne id

  up = doc.upVotes
  down = doc.votes - doc.upVotes

  naive = naiveScore up, down
  wilson = wilsonScore up, doc.votes
  hot = hotScore up, down, doc.date

  collection.update id,
    $set:
      score: naive
      best: wilson
      hot: hot
      value: Math.round 10*wilson

naiveScore = (up, down) ->
  return up - down

# http://amix.dk/blog/post/19588
wilsonScore = (pos, n) ->
  if n <= 0 or pos <= 0
    return 0

  # NOTE: hardcoded for performance (confidence = 0.95)
  z = 1.96
  phat = pos/n

  (phat + z*z/(2*n) - z * Math.sqrt((phat*(1-phat)+z*z/(4*n))/n))/(1+z*z/n)

# http://amix.dk/blog/post/19588
hotScore = (up, down, date) ->
  a = new Date(date).getTime()
  b = new Date(2005, 12, 8, 7, 46, 43).getTime()
  ts = a - b

  x = up - down

  if x > 0 then y = 1
  else if x < 0 then y = -1
  else y = 0

  z = Math.max(Math.abs(x), 1)

  Math.round(Math.log(z)/Math.log(10) + y*ts/45000)

notify = (skill, entity, target, receivers) ->
  Notifications.insert
    type: 'notification'
    date: entity.date
    skill: skill._id
    user: entity.user
    entity: entity._id
    entityType: entity.type
    target: target._id
    targetType: target.type
    targetUser: target.user
    receivers: receivers or [target.user]
    seen: []
