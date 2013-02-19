Template.user.events
  'click .pill': (e) ->
    e.stopImmediatePropagation()
    Session.toggle 'target', @_id
    if Session.equals 'target', @_id
      Session.set 'type', 'user'
      #Router.navigate @profile.username, false
    else
      Session.set 'type', null

Template.user.helpers
  title: ->
    if @title != '' then @title else '<No title>'

  description: ->
    if @description != '' then @description else '<No description>'

  votesDiff: ->
    @upVotes - (@votes - @upVotes)

  selected: -> 
    Session.equals 'target', @_id

  color: ->
    if Meteor.user()
      userId = Meteor.user()._id
      if userId == @title
        return 'completed'
      #if isActiveInCollection(Favourites, @_id, userId)
      #  return 'accepted'
      #else if Achievements.find().count() > 0
      #  return 'uncompleted'
    return ''
