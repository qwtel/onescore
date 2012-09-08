fetchUserInformation = (user) ->
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

Meteor.startup ->
  # Assign global ranks
  users = Meteor.users.find {},
    sort: score: -1

  users.observe
    added: (user, beforeIndex) ->
      unless user.username?
        Meteor.users.update user._id,
          $set:
            level: 1
            score: 0
            rank: beforeIndex + 1

      # fetch facebook data when a new user is added
      fetchUserInformation user

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

  Titles.find().observe
    # assing 'best' title to its achievement
    changed: (title) ->
      Meteor.call 'assignBestTitle', title

  Achievements.find().observe
    changed: (newDocument, atIndex, oldDocument) ->
      keys = ['description', 'category', 'tags']
      diff = computeDifference newDocument, oldDocument, keys 

      _.extend diff,
        entity: newDocument._id
        entityType: newDocument.type
        date: new Date()

      Revisions.insert diff

  Accomplishments.find().observe
    changed: (newDocument, atIndex, oldDocument) ->
      keys = ['story', 'tags']
      diff = computeDifference newDocument, oldDocument, keys

      _.extend diff,
        entity: newDocument._id
        entityType: newDocument.type
        date: new Date()

      Revisions.insert diff

symetricDifference = (a, b) ->
  union = _.union a, b
  intersection = _.intersection a, b
  _.difference union, intersection

computeDifference = (newDocument, oldDocument, keys) ->
  diff = {}
  _.each keys, (key) ->
    if _.isArray newDocument[key]
      sym = symetricDifference newDocument[key], oldDocument[key] 
      if _.size(sym) > 0 then diff[key] = sym

    else if _.isObject newDocument[key]
      throw new Error "#{key} is an Object, should recurse, but not implemented"

    else if newDocument[key] isnt oldDocument[key]
      diff[key] = oldDocument[key]

  return diff
