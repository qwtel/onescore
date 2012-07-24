Meteor.startup ->
  canModify = (userId, tasks) ->
    return _.all tasks, (task) ->
      return not task.privateTo or task.privateTo is userId

  ###
  Todos.allow
    insert: -> return true
    update: canModify
    remove: canModify
    fetch: ['privateTo']
  ###

  Comments.allow
    insert: -> return true
    #can't update or remove
