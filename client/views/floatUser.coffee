Template.floatUser.events
  'click .usr': (e) ->
    e.stopImmediatePropagation()
    clickPill this, e

Template.floatUser.helpers
  credibility: ->
    Math.round 100 * @best
