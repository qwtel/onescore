Template.singleAchievement.helpers
  user: -> Meteor.users.findOne _id: @user
  achievers: ->
    sel = Template.scope.getSelect()
    sel.entity = @_id
    sel.active = true

    sort = Template.sort.getSort()
    limit = Session.get("limit-#{@_id}") or 1
    Accomplishments.find sel,
      sort: sort
      limit: 3 * limit

  comments: ->
    sel = Template.scope.getSelect()
    sel.entity = @_id
    query = Comments.find sel
    if query.count() is 0 then return false

    sort = Template.sort.getSort()
    limit = Session.get("limit-#{@_id}") or 1
    Comments.find sel,
      sort: sort
      #limit: 3 * limit


  hasStory: ->
    @story? and @story != ''

  hasMore: ->
    sel = Template.scope.getSelect()
    sel.entity = @_id
    sel.active = true

    query = Accomplishments.find sel
    count = query.count()

    limit = Session.get("limit-#{@_id}") or 1
    return 3 * limit < count
