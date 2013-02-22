Template.achievement.events

Template.achievement.helpers
  hasBeenSelected: ->
    Session.get "target-#{@_id}"

  color: color

  hasMore: ->
    query = Achievements.find parent: @_id
    count = query.count()
    limit = Session.get("limit-#{@_id}") or 1
    return 3 * limit < count

  successors: ->
    sort = Template.sort.getSort()
    limit = Session.get("limit-#{@_id}") or 1

    Achievements.find parent: @_id,
      sort: sort
      #skip: 3 * (limit-1)
      limit: 3 * limit
