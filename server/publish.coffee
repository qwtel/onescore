Meteor.publish 'users', ->
  return Meteor.users.find()

Meteor.publish 'comments', ->
  return Comments.find()# topic: topic

Meteor.publish 'achievements', ->
  return Achievements.find()

Meteor.publish 'titles', (entity) ->
  return Titles.find entity: entity

Meteor.publish 'votes', ->
  return Votes.find()# user: @userId()

Meteor.publish 'favourites', ->
  return Favourites.find()# user: @userId()

Meteor.publish 'accomplishments', ->
  return Accomplishments.find()

Meteor.publish 'notifications', ->
  return Notifications.find {},
    sort: date: -1
    limit: 20

Meteor.publish 'explore', (sel, sort, page) ->
  return Achievements.find sel,
    sort: sort
    skip: 20*page
    limit: 20

Meteor.publish 'activities', (sel, sort, page) ->
