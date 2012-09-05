_.extend Template.achievement,
  events:
    'click .expand': (e) ->
      unless e.isPropagationStopped()
        Session.toggle 'expand', @_id
        e.stopPropagation()

    'click .fav': (e) ->
      data =
        entity: @_id

      Meteor.call 'favourite', data

    #'click .tag': (e) ->
    #  tag = $(e.currentTarget).data 'tag'
    #  Session.push 'tagFilter', tag

  faved: ->
    if Meteor.user()
      fav = Favourites.findOne
        user: Meteor.user()._id
        entity: @_id
        active: true
      if fav
        return 'active'
    return ''
  
  accepted: (id) ->
    fav = Favourites.findOne
      user: Meteor.user()._id
      entity: id
      active: true
    if fav
      return true
  
  completed: (id) ->
    acc = Accomplishments.findOne
      user: Meteor.user()._id
      entity: id
    if acc
      return true
  
  color: ->
    if this
      if Session.equals 'newAchievement', @_id
        return ''
    
    if Meteor.user()
      if Template.achievement.completed @_id
        return 'completed'
    
      if Template.achievement.accepted @_id
        return 'accepted'
    
      else if Achievements.find().count() > 0
        return 'uncompleted'
    
      return ''
  
  hasScore: ->
    if this and @score?
      return true
    return false
