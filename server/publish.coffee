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


Meteor.publish 'users', ->
  return Meteor.users.find()

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

