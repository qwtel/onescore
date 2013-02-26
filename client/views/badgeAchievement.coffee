Template.badgeAchievement.events
  'click .pill': (e) ->
    e.stopImmediatePropagation()
    clickPill this

  'click .nav': (e) ->
    e.stopImmediatePropagation()

Template.badgeAchievement.helpers
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

  hasBeenAccomplished: ->
    Session.get "accomplished-#{@_id}"

  remainingChars: ->
    140 - (Session.get('length') or 0)

  color: color
