_.extend Template.achievements,
  events:
    'click .new': (e) ->
      Session.toggle 'expand', @_id
      Session.set 'tab', 'edit'

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
      when 'hot' then data = score: -1
      when 'cool' then data = score: 1

      when 'new' then data = date: -1
      when 'old' then data = date: 1

      when 'best' then data = score: -1
      when 'wort' then data = score: 1

    a = Achievements.find sel,
      sort: data
    return a

  newAchievement: ->
    id = Session.get 'newAchievement'
    return Achievements.findOne id
