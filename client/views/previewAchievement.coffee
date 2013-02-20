Template.previewAchievement.helpers
  title: ->
    if @title != '' then @title else '<No title>'

  description: ->
    if @description != '' then @description else '<No description>'

  votesDiff: ->
    @upVotes - (@votes - @upVotes)

  level: ->
    id = Session.get 'id'
    if id 
      parent = Achievements.findOne id
      if parent
        return parent.level + 1
    return 1
