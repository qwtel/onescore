_.extend Template.accomplishment,
  events:
    'click .vote': (e) ->
      unless e.isPropagationStopped()
        $t = $(e.target)
        unless $t.hasClass 'vote' then $t = $t.parents '.vote'
        up = $t.data 'up'
        Meteor.call 'vote', 'accomplishments', @_id, up
        e.stopPropagation()

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

  voted: (state) ->
    state = if state is 'up' then true else false

    if Meteor.user()
      vote = Votes.findOne
        user: Meteor.user()._id
        entity: @_id
      if vote and vote.up is state
        return 'active'
    return ''

  numComments: ->
    c = Comments.find
      topic: @_id
    if c
      return c.count()
