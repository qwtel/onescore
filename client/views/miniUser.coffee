Template.miniUser.events
  'click .pill': (e) ->
    e.stopImmediatePropagation()
    clickPill this

  'click .nav': (e) ->
    e.stopImmediatePropagation()

Template.miniUser.helpers
  selected: -> 
    Session.equals 'target', @_id

  credibility: ->
    Math.round 100 * @best

  color: ->
    user = Meteor.user()
    if user.profile
      if user.profile.username == @profile.username
        return 'completed'
      #if isActiveInCollection(Favourites, @_id, userId)
      #  return 'accepted'
      #else if Achievements.find().count() > 0
      #  return 'uncompleted'
    return ''
