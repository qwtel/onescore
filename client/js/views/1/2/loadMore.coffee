_.extend Template.loadMore,
  events:
    'click .more': (e) ->
      skip = Session.get 'skip'
      skip++
      Session.set 'skip', skip


