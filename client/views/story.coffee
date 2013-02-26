Template.story.events
  'click .pill': (e) ->
    e.stopImmediatePropagation()
    clickPill this

  'click .nav': (e) ->
    e.stopImmediatePropagation()

Template.story.helpers
  selected: -> 
    Session.equals 'target', @_id

  isTweet: ->
    if @story
      @story.length <= 140

  votesDiff: ->
    @upVotes - (@votes - @upVotes)

  color: ->
    userId = Meteor.userId()
    if userId
      if userId == @user
        return 'completed'
      #if isActiveInCollection(Favourites, @_id, userId)
      #  return 'accepted'
      #else if Achievements.find().count() > 0
      #  return 'uncompleted'
    return ''
