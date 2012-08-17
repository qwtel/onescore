_.extend Template.accomplishment, Template.vote,
  achievement: ->
    sel = {}
    sel._id = @entity

    if Session.get('category')?
      sel.category = Session.get 'category'

    Achievements.findOne sel

  user: ->
    return Meteor.users.findOne @user
  
  verb: ->
    if @story and @story isnt ''
      return 'posted'
    else
      return 'accomplished'

  numComments: ->
    c = Comments.find
      topic: @_id
    if c
      return c.count()

_.extend Template.accomplishment.events, Template.vote.events
