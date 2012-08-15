Meteor.subscribe 'users'

Meteor.subscribe 'comments'

Meteor.autosubscribe ->
  achievement = Session.get 'single'
  if achievement
    Meteor.subscribe 'titles', achievement, ->

Meteor.subscribe 'achievements', ->
  id = window.createNewAchievement()
  Session.set 'newAchievement', id

Meteor.subscribe 'votes', ->

Meteor.subscribe 'favourites', ->

Meteor.subscribe 'accomplishments', ->
