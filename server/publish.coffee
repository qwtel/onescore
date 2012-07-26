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

Meteor.methods
  # TODO: Write a stub on client
  updateTitleScore: (id) ->
    upVotes = Votes.find(
      entity: id
      up: true
    ).count()

    downVotes = Votes.find(
      entity: id
      up: false
    ).count()

    Titles.update id,
      $set:
        score: upVotes - downVotes
    ,
      # Callback
      ->
        title = Titles.findOne {},
          sort:
            score: -1

        Achievements.update title.entity,
          $set:
            title: title.title
