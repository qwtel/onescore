Meteor.publish 'slideshows', ->
  return Slideshows.find()

Meteor.publish 'activities', ->
  return Activities.find()

Meteor.publish 'drafts', (user) ->
  return Drafts.find user: user

Meteor.publish 'ushers', ->
  return Ushers.find()

Meteor.publish 'slides', (slideshowId) ->
  return Slides.find slideshowId: slideshowId

Meteor.publish 'comments', (topic) ->
  return Comments.find topic: topic


Meteor.publish 'achievements', ->
  return Achievements.find()

Meteor.publish 'titles', (entity) ->
  return Titles.find entity: entity

Meteor.publish 'votes', ->
  return Votes.find user: @userId()

Meteor.publish 'favourites', ->
  return Favourites.find user: @userId()

Meteor.publish 'quests', ->
  return Quests.find user: @userId()

Meteor.publish 'accomplishments', ->
  return Accomplishments.find user: @userId()

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
