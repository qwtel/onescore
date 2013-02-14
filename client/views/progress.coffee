Template.progress.helpers
  progress: ->
    user = Meteor.user()
    if user and user.profile
      next = nextLevel user.profile.level
      inLevelScore = user.profile.score - prevLevels(user.profile.level) 
      inLevelScore = if (inLevelScore < 0) then 0 else inLevelScore
      100*inLevelScore/next

  progressText: ->
    user = Meteor.user()
    if user and user.profile
      next = nextLevel user.profile.level
      inLevelScore = user.profile.score - prevLevels(user.profile.level) 
      inLevelScore = if (inLevelScore < 0) then 0 else inLevelScore
      "#{inLevelScore}/#{next}"
