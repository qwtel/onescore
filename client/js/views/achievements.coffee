_.extend Template.achievements,
  select: ->
    sel = {}
    sel.created = true

    if Session.get('category')?
      sel.category = Session.get 'category'

    return sel

  achievements: ->
    sel = Template.achievements.select()
    sort = Session.get 'sort'

    switch sort
      when 'hot' then data = hot: -1
      when 'cool' then data = hot: 1

      when 'new' then data = date: -1
      when 'old' then data = date: 1

      when 'best' then data = best: -1
      when 'worst' then data = best: 1

    a = Achievements.find sel,
      sort: data
    return a
