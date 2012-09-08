Meteor.publish 'users', ->
  Meteor.users.find()

Meteor.publish 'comments', ->
  Comments.find()# topic: topic

Meteor.publish 'achievements', ->
  Achievements.find()

Meteor.publish 'titles', ->
  Titles.find() #entity: entity

Meteor.publish 'votes', ->
  Votes.find()# user: @userId()

Meteor.publish 'favourites', ->
  Favourites.find()# user: @userId()

Meteor.publish 'accomplishments', ->
  Accomplishments.find()

Meteor.publish 'notifications', (batch) ->
  Notifications.find
    receivers: @userId()
  ,
    sort: date: -1
    limit: 15*(batch+1)

Meteor.publish 'revisions', (document, batch) ->
  Revisions.find
    entity: document
  ,
    sort: date: -1
    limit: 15*(batch+1)

#Meteor.publish 'explore', (sel, sort, batch) ->
#  achievements = Achievements.find sel,
#    sort: sort
#    limit: 5*(batch+1)
#
#  return achievements
#
  #achievements = achievements.fetch()
  #_.each achievements, (achievement) =>
  #
  #  sel =
  #    user: @userId()
  #    entity: achievement._id
  #  options =
  #    fields: _id: 1
  #
  #  completed = Accomplishments.findOne sel, options
  #  sel.active = true
  #  faved = Favourites.findOne sel, options
  #
  #  achievement.completed = (completed)?
  #  achievement.faved = (faved)?
  #
  #  @set 'explore', achievement._id, achievement
  #  @set 'achievements', achievement._id, achievement
  #@flush()

#Meteor.publish 'activities', (sel, sort, page) ->
#  Notifications.find sel,
#    sort: sort
#    skip: 20*page
#    limit: 20

#Meteor.publish 'quests', (user) ->
#  unless user
#    user = @userId()
#  
#  favs = Favourites.find
#    user: user
#    active: true
#  ,
#    sort: date: -1
#    limit: 100
#  
  #favs.observe
  #  added: (fav) =>
  #    achievement = Achievements.findOne fav.entity
  #
  #    if achievement
  #      completed = Accomplishments.findOne
  #        user: user
  #        entity: achievement._id
  #      ,
  #        fields: _id: 1
  #
  #      unless completed
  #        achievement.faved = true
  #        achievement.completed = false
  #        #fav.achievement = achievement
  #        @set 'achievements', achievement._id, achievement
  #
  #        @set 'quests', fav._id, fav
  #        @flush()
  #
  #  changed: (fav) =>
  #    if fav.active
  #      @set 'quests', fav._id, fav
  #    else
  #      @unset 'quests', fav._id, _.keys(fav)
  #
  #  removed: (fav) =>
  #      @unset 'quests', fav._id, _.keys(fav)
  #    @flush()
