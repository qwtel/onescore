_.extend Template.accomplishment,
  events:
    'click .add-tag': (e) ->
      Session.set 'addingTag', @_id
      Meteor.flush()
      focusById('addingTag-'+@_id)

  achievement: ->
    sel = {}
    sel._id = @entity
  
    if Session.get('category')?
      sel.category = Session.get 'category'
  
    Achievements.findOne sel

  numComments: ->
    return @comments
    #c = Comments.find
    #  topic: @_id
    #if c
    #  return c.count()
