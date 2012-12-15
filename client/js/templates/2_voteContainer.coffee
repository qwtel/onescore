_.extend Template.voteContainer,
  events:
    'click .vote': (e) ->
      unless e.isPropagationStopped()
        e.stopPropagation()

        $t = $(e.target).closest '.vote'
        up = $t.data 'up'
        
        data =
          entity: @_id
          entityType: @type
          up: up

        Meteor.call 'vote', data

Template.voteContainer.helpers 
  score: ->
    @upVotes - (@votes - @upVotes)

  voted: (state) ->
    state = if state is 'up' then true else false

    if Meteor.user()
      vote = Votes.findOne
        user: Meteor.user()._id
        entity: @_id
      if vote and vote.up is state
        return 'active'
    return ''

