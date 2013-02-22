Template.profile.events

Template.profile.helpers
  user: ->
    id = Session.get 'id'
    Meteor.users.findOne id

  accomplishments: ->
    id = Session.get 'id'

    sel = {}
    sel.user = id
    sel.active = true

    sort = Template.sort.getSort()
    limit = Session.get('limit') or 1
    Accomplishments.find sel,
      sort: sort
      limit: 25 * limit

  achievement: ->
    Achievements.findOne @entity

  hasMore: ->
    id = Session.get 'id'

    sel = {}
    sel.user = id
    sel.active = true

    query = Accomplishments.find sel
    count = query.count()

    limit = Session.get('limit') or 1
    return 25 * limit < count
