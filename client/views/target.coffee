Template.target.events
  'click li': (e) ->
    e.stopImmediatePropagation()
    clickPill this

Template.target.rendered
Template.target.helpers
  entity: ->
    id = Session.get 'target'
    type = Session.get 'type'
    if id and type
      Collections[type].findOne id

  title: ->
    if @type?
      return strings @type
    else
      return strings 'user' # XXX

  selected: -> 
    Session.equals 'target', @_id

  color: color
