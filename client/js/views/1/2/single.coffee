_.extend Template.single,
  achievement: ->
    id = Session.get 'single'
    entity = Achievements.findOne id
    if entity
      Session.set 'topic', entity._id
      Session.set 'topicType', entity.type
      return entity

  accomplishment: ->
    id = Session.get 'single'
    entity = Accomplishments.findOne id
    if entity
      Session.set 'topic', entity._id
      Session.set 'topicType', entity.type
      return entity

  comment: ->
    id = Session.get 'single'
    comment = Comments.findOne id
    if comment
      Session.set 'topic', comment.topic
      Session.set 'topicType', comment.topicType
      Session.set 'parent', comment._id
      Session.set 'level', comment.level
      return comment
