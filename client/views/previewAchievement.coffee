Template.previewAchievement.helpers
  title: ->
    if @title != '' then @title else '<No title>'

  description: ->
    if @description != '' then @description else '<No description>'

  votesDiff: ->
    @upVotes - (@votes - @upVotes)
