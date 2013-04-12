Template.storyBar.events
  'click .click-me-im-famous': (e) ->
    e.stopImmediatePropagation()
    clickPill this, e

  'click .nav': (e) ->
    e.stopImmediatePropagation()

Template.storyBar.helpers
  selected: -> 
    Session.equals 'target', @_id

  votesDiff: ->
    @upVotes - (@votes - @upVotes)
