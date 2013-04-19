Template.profile.events
  'click .nav-tabs a': (e) ->
    if e.which is 1 and not (e.ctrlKey or e.metaKey)
      e.stopImmediatePropagation()
      e.preventDefault()
      $t = $(e.currentTarget)
      tab = $t.data 'tab'
      Session.set 'tab-user', tab
      #href = $t.attr 'href'
      #Router.navigate href, false

Template.profile.helpers
  activity: ->
    userId = @_id
    if userId
      limit = Session.get('limit') or 1

      sel = 
        user: userId

      Notifications.find sel,
        sort: date: -1
        limit: 10 * limit

  hasMoreActivity: ->
    userId = @_id
    query = Notifications.find 
      user: userId

    count = query.count()
    limit = Session.get("limit") or 1
    return 10 * limit < count

  accomplishments: ->
    sel =
      user: @_id
      active: true

    sort = Template.sort.getSort()
    limit = Session.get("limit-#{@_id}") or 1
    Accomplishments.find sel,
      sort: sort
      limit: 5 * limit

  quests: ->
    userId = @_id
    sel =
      user: @_id
      active: true
      $where: ->
        a = Accomplishments.findOne
          user: userId
          entity: @entity
          active: true
        !a

    sort = Template.sort.getSort()
    limit = Session.get("limit-#{@_id}") or 1
    Favourites.find sel,
      sort: sort
      limit: 10 * limit

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

    limit = Session.get("limit-#{@_id}") or 1
    return 10 * limit < count
