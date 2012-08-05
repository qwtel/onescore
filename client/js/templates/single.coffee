_.extend Template.single,
  achievement: ->
    id = Session.get 'single'
    return Achievements.findOne id

  accomplishment: ->
    id = Session.get 'single'
    return Accomplishments.findOne id
