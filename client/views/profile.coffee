Template.profile.events

Template.profile.helpers
  accomplishments: ->
    sel =
      user: @_id
      active: true

    sort = Template.sort.getSort()
    limit = Session.get('limit') or 1
    Accomplishments.find sel,
      sort: sort
      limit: 25 * limit

  achievement: ->
    Achievements.findOne @entity

  hasStory: ->
    (@story? and @story != '') 

  hasMore: ->
    sel =
      user: @_id
      active: true

    query = Accomplishments.find sel
    count = query.count()

    limit = Session.get('limit') or 1
    return 25 * limit < count
