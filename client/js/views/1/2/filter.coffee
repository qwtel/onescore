_.extend Template.filter,
  events:
    'change .sort': (e) ->
      $t = $(e.currentTarget)
      Session.set 'sort', $t.find(':selected').val()

    'click .tab': (e) ->
      $t = $(e.currentTarget)
      Session.set 'limit', $t.data 'tab'

    'keyup .search-query,  keydown .search-query':
      makeOkCancelHandler
        ok: (text, e) ->
          tags = window.findTags text
          if tags[0]
            Session.set 'tagFilter', tags[0]

  sort: ->
    sort = Session.get 'sort'

    switch sort
      when 'hot' then data = hot: -1
      when 'cool' then data = hot: 1

      when 'new' then data = date: -1
      when 'old' then data = date: 1

      when 'best' then data = best: -1
      when 'worst' then data = best: 1

    return data

  limit: ->
    return

  query: ->
    tag = Session.get 'tagFilter'
    if tag
      return "##{tag}"
