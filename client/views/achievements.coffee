Template.achievements.events

Template.achievements.helpers
  achievements: ->
    sel = Template.scope.getSelect()
    sel.parent = null

    sort = Template.sort.getSort()
    limit = Session.get('limit') or 1
    Achievements.find sel,
      sort: sort
      limit: 5 * limit

  hasMore: ->
    sel = Template.scope.getSelect()
    sel.parent = null

    query = Achievements.find sel
    count = query.count()
    limit = Session.get("limit") or 1
    return 5 * limit < count

