Template.baseAchievement.events
  'click .achievement': (e) ->
    e.stopImmediatePropagation()
    clickPill this

  'click .nav': (e) ->
    e.stopImmediatePropagation()

  'click .add-story': (e) ->
    text = $("#accomplished-#{@_id}").val()
    if text isnt ''
      Meteor.call 'accomplish', @_id, text
    Session.set "accomplished-#{@_id}", false

  'keydown textarea': (e) ->
    length = $(e.currentTarget).val().length
    Session.set 'length', length

Template.baseAchievement.rendered = ->
  length = $(@find('textarea')).val().length
  Session.set 'length', length

Template.baseAchievement.helpers
  title: ->
    if @title != '' then @title else '<No title>'
  
  description: ->
    if @description != '' then @description else '<No description>'
  
  votesDiff: ->
    @upVotes - (@votes - @upVotes)
  
  selected: -> 
    Session.equals 'target', @_id
  
  story: ->
    acc = Accomplishments.findOne entity: @_id
    if acc then acc.story else ''

  hasBeenSelected: ->
    Session.get "target-#{@_id}"

  hasBeenAccomplished: ->
    Session.equals "accomplished", @_id

  remainingChars: ->
    140 - (Session.get('length') or 0)

  color: color
