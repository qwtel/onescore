Template.miniUser.events
  'click .pill': (e) ->
    e.stopImmediatePropagation()
    clickPill this, e

  'click .nav': (e) ->
    e.stopImmediatePropagation()

Template.miniUser.helpers
  selected: -> 
    Session.equals 'target', @_id

  credibility: ->
    Math.round 100 * @best
