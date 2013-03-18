Template.achievements.events

Template.achievements.helpers
  achievements: ->
    sel = Template.scope.getSelect()
    sel.parent = null
    userId = Meteor.userId()
    sel.$where = ->
      a = Accomplishments.findOne
        user: userId
        entity: @_id
      return not a

    sort = Template.sort.getSort()
    limit = Session.get('limit') or 1
    Achievements.find sel,
      sort: sort
      limit: 10 * limit

  hasMore: ->
    sel = Template.scope.getSelect()
    sel.parent = null

    query = Achievements.find sel
    count = query.count()
    limit = Session.get("limit") or 1
    return 10 * limit < count

