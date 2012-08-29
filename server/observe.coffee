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

    #console.log res
    #friends = Meteor.users.find(
    #  'services.facebook.id':
    #    $in:
    #      res.data.friends
    #  ,
    #    fields: ['_id']
    #).fetch()

nextLevel = (level) ->
  # HACK: this should be some exponential formula.
  # HACK: this should be part of a user model.
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

  #rank = 1
  #users.forEach (user) ->
  #  Meteor.users.update user._id,
  #    $set:
  #      rank: rank
  #  rank++

  users.observe
    # fetch facebook data when a new user is added
    added: (user, beforeIndex) ->
      unless user.username?
        Meteor.users.update user._id,
          $set:
            level: 1
            score: 0
            rank: beforeIndex + 1

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

    #added: (title) ->
    #  achievement = Achievements.findOne title.entity
    #  notify title, achievement

  #Accomplishments.find().observe
  #  added: (accomplishment) ->
  #    achievement = Achievements.findOne accomplishment.entity
  #    notify accomplishment, achievement
  
  #Votes.find().observe
  #  added: (vote) ->
  #    target = Collections[vote.entityType].findOne vote.entity
  #    notify vote, target
  
  #Comments.find().observe
  #  added: (comment) ->
  #    target = Collections[comment.topicType].findOne comment.topic
  #    notify comment, target
  #
  #    if comment.parent?
  #      parent = Comments.findOne comment.parent
  #      notify comment, parent
  #
  #    Collections[comment.topicType].update comment.topic,
  #      $inc:
  #        comments: 1
  #
  #  removed: (comment) ->
  #    Collections[comment.topicType].update comment.topic,
  #      $inc:
  #        comments: -1

  #Achievements.find().observe
  #  added: (entity) ->
  #  changed: (achievement) ->

