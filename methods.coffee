Meteor.methods
  newAchievement: (data) ->
    user = Meteor.user()
    skill = Skills.findOne 'newAchievement'
    if !isAllowedToUseSkill user, skill
      return 0

    # XXX: This is not good (in so many respects I don't even know where to
    # start)
    delete data._id
    _.extend data, basic(),
      favourites: 0
      accomplishments: 0
    data.type = 'achievement'

    # achievements have levels based on the number of predecessors
    data.level = 1
    if data.parent
      parent = Achievements.findOne data.parent
      data.level = parent.level + 1

    id = Achievements.insert data

    #if data.title
    #  titleData =
    #    title: data.title
    #    entity: id
    #
    #  Meteor.call 'suggestTitle', titleData

    return id 

  favourite: (data) ->
    user = Meteor.user()
    skill = Skills.findOne 'favourite'
    if !isAllowedToUseSkill user, skill then return 0 

    fav = Favourites.findOne
      user: @userId
      entity: data.entity
    
    if fav
      Favourites.update fav._id,
        $set:
          active: !fav.active
    else
      _.extend data, basic(),
        type: 'favourite'
        active: true
      Favourites.insert data
      Achievements.update data.entity,
        $inc:
          favourites: 1

  accomplish: (data) ->
    user = Meteor.user()
    skill = Skills.findOne 'accomplish'
    if !isAllowedToUseSkill user, skill then return 0

    acc = Accomplishments.findOne
      user: @userId
      entity: data.entity

    if acc
      Accomplishments.update acc._id,
        $set:
          active: !acc.active
    else
      _.extend data, basic(),
        type: 'accomplishment'
        active: true

      id = Accomplishments.insert data
      Achievements.update data.entity,
        $inc:
          accomplishments: 1

      # update user xp
      achievement = Achievements.findOne data.entity
      Meteor.users.update user._id,
        $inc:
          'profile.xp': achievement.value

      # level up?
      next = nextLevel user.profile.level
      inLevelXp = user.profile.xp - prevLevels(user.profile.level) 
      if inLevelXp >= next
        Meteor.users.update user._id,
          $inc:
            'profile.level': 1

      # send notificatións
      #accomplishment = Accomplishments.findOne accomplishId
      #notify accomplishment, achievement

    #Meteor.call 'upload', formData, accomplishId
    return id or acc._id

  voteUp: (id, type) ->
    user = Meteor.user()
    skill = Skills.findOne 'voteUp'
    if !isAllowedToUseSkill user, skill then return 0
    voteFor user, id, type, true

  voteDown: (id, type) ->
    user = Meteor.user()
    skill = Skills.findOne 'voteDown'
    if !isAllowedToUseSkill user, skill then return 0
    voteFor user, id, type, false

voteFor = (user, id, type, active) ->
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
        #$set: lastVote: new Date().getTime()
        $inc: upVotes: diff

  else
    _.extend data,
      type: 'vote'
      upVotes: 0
      votes: 0

    id = Votes.insert data

    vote = Votes.findOne id
    target = Collections[vote.entityType].findOne vote.entity
    #notify vote, target
    
    Collections[vote.entityType].update vote.entity, 
      #$set: lastVote: new Date().getTime()
      $inc: 
        upVotes: if data.active then 1 else 0
        votes: 1

  calculateScore Collections[data.entityType], data.entity

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

# XXX: I'm too stupid to write this function. 
# please fix that LastChanged gets updated on every try, thanks.
isAllowedToUseSkill = (user, skill) ->

  #if _.has(skill, 'level')
  #  unless user.level >= skill.level
  #    return false

  if _.has(skill, 'cooldown')
    time = new Date().getTime()
    isAllowed = true
    if _.has(user.profile, skill._id+'LastChanged')
      if (user.profile[skill._id+'LastChanged'] + skill.cooldown*1000) > time
        isAllowed = false

    # XXX: this could possibly override other updates to user.profile
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
  date: new Date().getTime()
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
