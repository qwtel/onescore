Template.loadMore.events
  'click *': (e) ->
    e.stopImmediatePropagation()

    if _.has(this, '_id')
      limit = Session.get("limit-#{@_id}") or 1
      Session.set "limit-#{@_id}", limit + 1
    else
      limit = Session.get('limit') or 1
      Session.set 'limit', limit + 1

Template.loadMore.helpers
