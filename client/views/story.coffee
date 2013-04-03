Template.story.events
  'click .story': (e) ->
    e.stopImmediatePropagation()
    clickPill this, e

  'click .nav': (e) ->
    e.stopImmediatePropagation()

Template.story.helpers
  selected: -> 
    Session.equals 'target', @_id

  #isTweet: ->
  #  if @story
  #    @story.length <= 140

  votesDiff: ->
    @upVotes - (@votes - @upVotes)

  image: ->
    if @imgur?
      split = @imgur.link.split('.')
      fileExtension = split[split.length-1]
      return "http://i.imgur.com/#{@imgur.id}l.#{fileExtension}"
