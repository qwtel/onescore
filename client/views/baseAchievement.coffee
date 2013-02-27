Template.baseAchievement.events
  'click .achievement': (e) ->
    e.stopImmediatePropagation()
    clickPill this

  'click .nav': (e) ->
    e.stopImmediatePropagation()

Template.baseAchievement.helpers
  title: ->
    if @title != '' then @title else '<No title>'
  
  description: ->
    if @description != '' then @description else '<No description>'
  
  votesDiff: ->
    @upVotes - (@votes - @upVotes)
  
  selected: -> 
    Session.equals 'target', @_id
  
  hasBeenSelected: ->
    Session.get "target-#{@_id}"

  color: color
