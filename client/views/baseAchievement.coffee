Template.baseAchievement.events
  'click .pill': (e) ->
    e.stopImmediatePropagation()
    clickPill this

  'click .nav': (e) ->
    e.stopImmediatePropagation()

  'click .add-story': (e) ->
    text = $("#accomplished-#{@_id}").val()
    Meteor.call 'accomplish', @_id, text
    Session.set "accomplished-#{@_id}", false

  'keydown textarea': (e) ->
    length = $(e.currentTarget).val().length
    Session.set 'length', length

#Template.baseAchievement.rendered = -> console.log 'rendered'
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

  hasBeenAccomplished: ->
    Session.get "accomplished-#{@_id}"

  remainingChars: ->
    140 - (Session.get('length') or 0)

  color: color
