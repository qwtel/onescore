Template.achievement.events
  'click .pill': (e) ->
    e.stopImmediatePropagation()
    Session.toggle 'target', @_id
    if Session.equals 'target', @_id
      Session.set 'type', 'achievement'
      #Router.navigate "achievement/#{@_id}", false
    else
      Session.set 'type', null

Template.achievement.rendered = -> console.log 'rendered'

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
    false

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
    return ''
  
  images: ->
    (Accomplishments.find
      entity: @_id
      image: $ne: null
    ).fetch()

  stories: ->
    console.log (Accomplishments.find
      entity: @_id
      story: $ne: null
    ).fetch()

  achievers: ->
    console.log (Accomplishments.find
      entity: @_id
    ).fetch()
