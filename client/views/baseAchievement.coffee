Template.baseAchievement.events
  'click .achievement': (e) ->
    e.stopImmediatePropagation()
    clickPill this, e

  'click .nav': (e) ->
    e.stopImmediatePropagation()

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

  icon: ->
    if @imgur?
      split = @imgur.link.split('.')
      fileExtension = split[split.length-1]
      return "http://i.imgur.com/#{@imgur.id}t.#{fileExtension}"
    else
      return '/img/bg_new.png'
