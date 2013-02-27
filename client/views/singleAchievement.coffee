Template.singleAchievement.helpers
  user: -> Meteor.users.findOne _id: @user
  achievers: ->
    sel = Template.scope.getSelect()
    sel.entity = @_id
    sel.active = true

    sort = Template.sort.getSort()
    limit = Session.get('limit') or 1
    Accomplishments.find sel,
      sort: sort
      limit: 3 * limit

  hasStory: ->
    @story? and @story != ''

  hasMore: ->
    sel = Template.scope.getScope()
    sel.active = true
    sel.story = $ne: ''

    query = Accomplishments.find sel
    count = query.count()

    limit = Session.get('limit') or 1
    return 3 * limit < count
