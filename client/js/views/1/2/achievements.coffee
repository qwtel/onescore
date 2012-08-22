_.extend Template.achievements,
  select: ->
    sel = {}
    sel.created = true

    if Session.get('category')?
      sel.category = Session.get 'category'

    if Session.get('tagFilter')?
      sel.tags = Session.get 'tagFilter'

    return sel

  achievements: ->
    sel = Template.achievements.select()
    sort = Template.filter.sort()

    a = Achievements.find sel,
      sort: sort
    return a
