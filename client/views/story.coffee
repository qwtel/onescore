Template.story.helpers
  hasContent: ->
    (@story? and @story.length isnt 0) or @imgur?

  image: ->
    if @imgur?
      split = @imgur.link.split('.')
      fileExtension = split[split.length-1]
      return "http://i.imgur.com/#{@imgur.id}l.#{fileExtension}"
