Template.loadMore.events
  'click *': (e) ->
    e.stopImmediatePropagation()
    limit = Session.get 'limit'
    Session.set 'limit', limit + 1

Template.loadMore.helpers
