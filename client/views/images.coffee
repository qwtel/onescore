Template.images.events
  'click .pill': (e) ->
    e.stopImmediatePropagation()

Template.images.rendered = -> console.log 'rendered'

Template.images.helpers
  images: ->
    [
      active: true
    ,
      active: false
    ,
      active: false
    ]
