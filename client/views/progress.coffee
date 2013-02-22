Template.progress.helpers
  progress: ->
    if this and @profile
      next = nextLevel @profile.level
      inLevelScore = @profile.xp - prevLevels(@profile.level) 
      inLevelScore = if (inLevelScore < 0) then 0 else inLevelScore
      100*inLevelScore/next

  progressText: ->
    if this and @profile
      next = nextLevel @profile.level
      inLevelScore = @profile.xp - prevLevels(@profile.level) 
      inLevelScore = if (inLevelScore < 0) then 0 else inLevelScore
      "#{inLevelScore}/#{next}"
