_.extend Template.progress,
  progress: ->
    user = Meteor.user()
    if user and !user.loading
      next = Template.body.nextLevel user.level
      return 100*user.score/next

  progressText: ->
    user = Meteor.user()
    if user and !user.loading
      next = Template.body.nextLevel user.level
      return "#{user.score}/#{next}"
