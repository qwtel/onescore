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

Meteor.publish 'dashboardComments', ->
  return DashboardComments.find()
