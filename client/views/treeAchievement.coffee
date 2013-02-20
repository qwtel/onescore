Template.treeAchievement.helpers
  successors: ->
    Achievements.find parent: @_id,
      sort: best: -1
      #limit: 3

  completed: ->
    isActiveInCollection Accomplishments, @_id, Meteor.userId()

  accepted: ->
    isActiveInCollection Favourites, @_id, Meteor.userId()

  color: ->
    user = Meteor.user()
    if user
      userId = user._id
      if isActiveInCollection Accomplishments, @_id, userId
        return 'completed'
      if isActiveInCollection Favourites, @_id, userId
        return 'accepted'
      else if Achievements.find().count() > 0
        return 'uncompleted'
