_.extend Template.single,
  achievement: ->
    id = Session.get 'single'
    entity = Achievements.findOne id
    if entity
      Session.set 'topic', entity._id
      return entity

  accomplishment: ->
    id = Session.get 'single'
    entity = Accomplishments.findOne id
    if entity
      Session.set 'topic', entity._id
      return entity

  comment: ->
    id = Session.get 'single'
    entity = Comments.findOne id
    if entity
      Session.set 'topic', entity.topic
      Session.set 'parent', entity._id
      Session.set 'level', entity.level
      return entity
