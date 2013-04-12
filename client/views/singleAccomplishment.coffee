Template.singleAccomplishment.events
  'click .nav-tabs a': (e) ->
    if e.which is 1 and not (e.ctrlKey or e.metaKey)
      e.stopImmediatePropagation()
      e.preventDefault()
      $t = $(e.currentTarget)
      tab = $t.data 'tab'
      Session.set 'tab-accomplishment', tab

Template.singleAccomplishment.helpers
  user: -> Meteor.users.findOne _id: @user

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

  voters: ->
    sel = Template.scope.getSelect()
    sort = Template.sort.getSort()
    limit = Session.get("limit-#{@_id}") or 1

    entity = @_id
    sel.$where = ->
      Votes.findOne
        user: @_id
        entity: entity

    Meteor.users.find sel,
      sort: sort
      #limit: 3 * limit

  #hasMore: ->
  #  sel = Template.scope.getSelect()
  #  sel.entity = @_id
  #  sel.active = true
  #
  #  query = Accomplishments.find sel
  #  count = query.count()
  #
  #  limit = Session.get("limit-#{@_id}") or 1
  #  return 3 * limit < count
