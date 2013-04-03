Template.home.helpers
  user: ->
    id = Session.get 'id'
    Meteor.users.findOne id

  accomplishments: ->
    sel = Template.scope.getSelect()
    sel.active = true

    sort = Template.sort.getSort()
    limit = Session.get('limit') or 1

    Accomplishments.find sel,
      sort: sort
      limit: 15 * limit

  achievement: ->
    Achievements.findOne @entity

  hasMore: ->
    sel = Template.scope.getSelect()
    sel.active = true
    sel.story = $exists: true

    query = Accomplishments.find sel
    count = query.count()

    limit = Session.get('limit') or 1
    return 15 * limit < count
