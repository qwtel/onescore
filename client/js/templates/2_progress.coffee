_.extend Template.progress,
  progress: ->
    user = Meteor.user()
    if user and user.score and user.level
      next = nextLevel user.level
      inLevelScore = user.score - prevLevels(user.level) 
      inLevelScore = if (inLevelScore < 0) then 0 else inLevelScore
      return 100*inLevelScore/next

  progressText: ->
    user = Meteor.user()
    if user and user.score and user.level
      next = nextLevel user.level
      inLevelScore = user.score - prevLevels(user.level) 
      inLevelScore = if (inLevelScore < 0) then 0 else inLevelScore
      return "#{inLevelScore}/#{next}"

