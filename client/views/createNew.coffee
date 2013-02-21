Template.createNew.events
  'click *': (e) ->
    e.stopImmediatePropagation()

    if _.has(this, '_id')
      Router.navigate "/achievement/#{@_id}/new", true
    else
      Router.navigate "/achievement/new", true

Template.createNew.helpers
