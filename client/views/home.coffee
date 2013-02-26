Template.home.helpers
  user: ->
    id = Session.get 'id'
    Meteor.users.findOne id

  accomplishments: ->
    sel = Template.scope.getSelect()
    sel.active = true
    sel.story = $exists: true

    sort = Template.sort.getSort()
    limit = Session.get('limit') or 1
    Accomplishments.find sel,
      sort: sort
      limit: 25 * limit

  achievement: ->
    Achievements.findOne @entity

  hasStory: ->
    @story? and @story != ''

  hasMore: ->
    sel = Template.scope.getScope()
    sel.active = true
    sel.story = $ne: ''

    query = Accomplishments.find sel
    count = query.count()

    limit = Session.get('limit') or 1
    return 25 * limit < count
