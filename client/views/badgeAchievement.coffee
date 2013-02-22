Template.badgeAchievement.events
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

  color: color
