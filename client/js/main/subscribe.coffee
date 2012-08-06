Session.set 'styleGuide', true
Session.set 'editUsername', false

Meteor.subscribe 'ushers', ->
  if cookie.get 'user'
    userId = cookie.get('user')
    Session.set 'user', userId
  else
    userName = Math.floor(1000000 + (Math.random() * ((9999999 - 1000000) + 1)))
    userId = Ushers.insert name: userName
    Session.set 'user', userId
    cookie.set 'user', userId

Session.set 'activitiesLoaded', false
Meteor.subscribe 'activities', ->
  Session.set 'activitiesLoaded', true

Meteor.subscribe 'drafts', Session.get 'user'

Session.set 'topic', 'dashboard'
Meteor.autosubscribe ->
  topic = Session.get 'single'
  if topic
    Session.set 'commentsLoaded', false
    Meteor.subscribe 'comments', topic, ->
      Session.set 'commentsLoaded', true

  achievement = Session.get 'single'
  if achievement
    Session.set 'titlesLoaded', false
    Meteor.subscribe 'titles', achievement, ->
      Session.set 'titlesLoaded', true

Session.set 'achievements', false
Meteor.subscribe 'achievements', ->
  Session.set 'achievementsLoaded', true
  id = window.createNewAchievement()
  Session.set 'newAchievement', id

Session.set 'votesLoaded', false
Meteor.subscribe 'votes', ->
  Session.set 'votesLoaded', true

Session.set 'favsLoaded', false
Meteor.subscribe 'favourites', ->
  Session.set 'favsLoaded', true

#Session.set 'questsLoaded', false
#Meteor.subscribe 'quests', ->
#  Session.set 'questsLoaded', true

Meteor.subscribe 'users'

Session.set 'accomplishmentsLoaded', false
Meteor.subscribe 'accomplishments', ->
  Session.set 'accomplishmentsLoaded', true
