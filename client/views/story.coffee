Template.story.events
  'click .click-me-im-famous': (e) ->
    e.stopImmediatePropagation()
    clickPill this, e

  'click .nav': (e) ->
    e.stopImmediatePropagation()

Template.story.helpers
  selected: -> 
    Session.equals 'target', @_id

  hasContent: ->
    (@story? and @story.length isnt 0) or @imgur?

  votesDiff: ->
    @upVotes - (@votes - @upVotes)

  image: ->
    if @imgur?
      split = @imgur.link.split('.')
      fileExtension = split[split.length-1]
      return "http://i.imgur.com/#{@imgur.id}l.#{fileExtension}"
