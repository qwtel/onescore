Template.comment.events
  'click .comment': (e) ->
    e.stopImmediatePropagation()
    clickPill this, e

  'click .nav': (e) ->
    e.stopImmediatePropagation()

Template.comment.helpers
  user: -> Meteor.users.findOne _id: @user
  votesDiff: ->
    @upVotes - (@votes - @upVotes)
  
  selected: -> 
    Session.equals 'target', @_id
  
  hasBeenSelected: ->
    !Session.get "target-#{@_id}"

  successors: ->
    sel = Template.scope.getSelect()
    sel.entity = @_id
    query = Comments.find sel
    if query.count() is 0 then return false

    sort = Template.sort.getSort()
    limit = Session.get("limit-#{@_id}") or 1
    Comments.find sel,
      sort: sort
      #limit: 3 * limit
