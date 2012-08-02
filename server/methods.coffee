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
