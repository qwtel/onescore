_.extend Template.filter,
  events:
    'change .sort': (e) ->
      $t = $(e.target).closest '.sort'
      Session.set 'sort', $t.find(':selected').val()

    'click .tab': (e) ->
      $t = $(e.target).closest '.tab'
      Session.set 'limit', $t.data 'tab'

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
