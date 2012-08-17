Template.vote =
  events:
    'click .vote': (e) ->
      unless e.isPropagationStopped()
        $t = $(e.target).closest '.vote'
        up = $t.data 'up'
        
        data =
          entity: @_id
          entityType: @type
          up: up

        Meteor.call 'vote', data

        e.stopPropagation()

  voted: (state) ->
    state = if state is 'up' then true else false

    if Meteor.user()
      vote = Votes.findOne
        user: Meteor.user()._id
        entity: @_id
      if vote and vote.up is state
        return 'active'
    return ''
