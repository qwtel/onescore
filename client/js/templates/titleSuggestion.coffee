_.extend Template.titleSuggestions,
  events:
    'click .vote': (e) ->
      unless e.isPropagationStopped()
        $t = $(e.target)
        unless $t.hasClass 'vote' then $t = $t.parents '.vote'
        up = $t.data 'up'
        Meteor.call 'vote', 'titles', @_id, up
        e.stopPropagation()

  titles: ->
    id = Session.get 'expand'
    titles = Titles.find
      entity: id
      user: Meteor.user()._id
    ,
      sort:
        score: -1

    return titles

  voted: (state) ->
    state = if state is "up" then true else false

    vote = Votes.findOne
      user: Meteor.user()._id
      entity: @_id
    if vote and vote.up is state
      return 'active'
    return ''

