Template.achievement.events
  'click .pill': (e) ->
    e.stopImmediatePropagation()
    Session.toggle 'target', @_id
    if Session.equals 'target', @_id
      Session.set 'type', 'achievement'
      #Router.navigate "achievement/#{@_id}", false
    else
      Session.set 'type', null

  'click .nav': (e) ->
    e.stopImmediatePropagation()

Template.achievement.helpers
  title: ->
    if @title != '' then @title else '<No title>'
  
  description: ->
    if @description != '' then @description else '<No description>'
  
  votesDiff: ->
    @upVotes - (@votes - @upVotes)
  
  selected: -> 
    if Session.equals 'target', @_id
      Session.set "target-#{@_id}", true
      return true
  
  hasBeenSelected: ->
    Session.get "target-#{@_id}"

  color: ->
    user = Meteor.user()
    if user
      userId = user._id
      if isActiveInCollection Accomplishments, @_id, userId
        return 'completed'
      if isActiveInCollection Favourites, @_id, userId
        return 'accepted'
      else if Achievements.find().count() > 0
        return 'uncompleted'

  hasMore: ->
    query = Achievements.find parent: @_id
    count = query.count()
    limit = Session.get("limit-#{@_id}") or 1
    return 3 * limit < count

  successors: ->
    sort = Template.filter.getSort()
    limit = Session.get("limit-#{@_id}") or 1

    Achievements.find parent: @_id,
      sort: sort
      #skip: 3 * (limit-1)
      limit: 3 * limit
