# HACK: this should be some exponential formula.
# HACK: this should be part of a user model.
nextLevel = (level) ->
  next = 0
  switch level
    when 1 then next = 10
    when 2 then next = 25
    when 3 then next = 125
    when 4 then next = 525
    when 5 then next = 1225
  return next

# XXX: List of allowed facebook ids
betaKeys = ["1237137766"]

Accounts.onCreateUser (options, user) ->
  if options.profile
    user.profile = options.profile

  url = "https://graph.facebook.com/#{user.services.facebook.id}"
  query =
    params:
      access_token: user.services.facebook.accessToken

  res = Meteor.http.get url, query 

  if !res or !res.data or !res.data.username 
    throw new Error

  if not _.contains(betaKeys, res.data.id)
    throw new Error

  _.extend user,
    type: 'user'
    date: new Date().getTime()
    score: 0
    hot: 0
    best: 0
    value: 0
    comments: 0
    username: res.data.username
    level: 0
    rank: 0
    ranked: false

  _.extend user.profile,
    username: res.data.username
    bio: res.data.bio
    location: res.data.location.name

  return user

Meteor.startup ->
  # Assign global ranks
  users = Meteor.users.find {},
    sort: score: -1

  users.observe
    added: (user, beforeIndex) ->
      unless user.ranked
        Meteor.users.update user._id,
          $set:
            ranked: true
            level: 1
            rank: beforeIndex + 1

    changed: (user) ->
      next = nextLevel user.level
      if user.score >= next
        Meteor.users.update user._id,
          $inc:
            level: 1

    # keep ladder rank up to date
    moved: (user, oldRank, newRank) ->
      Meteor.users.update user._id,
        $set:
          rank: newRank

  #Votes.find().observe
  #  added: (vote) ->
  #    calculateScore Collections[vote.entityType] vote.entity
  #
  #  changed: (vote) ->
  #    calculateScore Collections[vote.entityType] vote.entity

  Titles.find().observe
    changed: (title) ->
      # assing 'best' title to its achievement
      Meteor.call 'assignBestTitle', title

  Achievements.find().observe
    changed: (newDocument, atIndex, oldDocument) ->

      #calculateScore Collections[newDocument.entityType], newDocument.entity

      keys = ['description', 'category', 'tags']
      diff = computeDifference newDocument, oldDocument, keys 

      if _.size(diff) > 0
        data =
          type: 'revision'
          entity: newDocument._id
          entityType: newDocument.type
          date: new Date().getTime()
          user: newDocument.lastModifiedBy
          diff: diff

        Revisions.insert data

  Accomplishments.find().observe
    changed: (newDocument, atIndex, oldDocument) ->
      keys = ['story', 'tags']
      diff = computeDifference newDocument, oldDocument, keys

      if _.size(diff) > 0
        data =
          type: 'revision'
          entity: newDocument._id
          entityType: newDocument.type
          date: new Date().getTime()
          user: newDocument.lastModifiedBy
          diff: diff

      Revisions.insert data

symetricDifference = (a, b) ->
  union = _.union a, b
  intersection = _.intersection a, b
  _.difference union, intersection

computeDifference = (newDocument, oldDocument, keys) ->
  diff = {}
  _.each keys, (key) ->
    if _.isArray newDocument[key]
      added = _.difference newDocument[key], oldDocument[key] 
      removed = _.difference oldDocument[key], newDocument[key] 

      if _.size(added) > 0
        diff[key] or (diff[key] = {})
        diff[key]['added'] = added

      if _.size(removed) > 0
        diff[key] or (diff[key] = {})
        diff[key]['removed'] = removed

    else if _.isObject newDocument[key]
      throw new Error "#{key} is an Object, should recurse, but not implemented"

    else if newDocument[key] isnt oldDocument[key]
      diff[key] = oldDocument[key]

  return diff
