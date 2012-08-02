countVotes = (id, up) ->
  return Votes.find(
    entity: id
    up: up
  ).count()

# TODO: Better score formula...
calculateScore = (id) ->
  up = countVotes id, true
  down = countVotes id, false
  return up - down

updateScore = (collection, id, score, callback) ->
  collection.update id,
    $set:
      score: score
    ,
      callback

Meteor.methods
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

  accomplish: (id, stry) ->
    acc = Accomplishments.findOne
      user: @userId()
      entity: id

    if acc
      Accomplishments.update acc._id,
        $set:
          story: stry
    else
      Accomplishments.insert
        user: @userId()
        entity: id
        story: stry

      a = Achievements.findOne id
      if a
        Meteor.users.update @userId(),
          $inc:
            score: a.score

  # TODO: Write stubs on client
  updateAchievementScore: (id) ->
    score = calculateScore id
    updateScore Achievements, id, score

  updateTitleScore: (titleId, achievementId) ->
    score = calculateScore titleId
    updateScore Titles, titleId, score, ->
      best = Titles.findOne
        entity: achievementId
      ,
        sort:
          score: -1

      if best
        Achievements.update achievementId,
          $set:
            title: best.title
