Template.userBanner.events
  'click .pill': (e) ->
    e.stopImmediatePropagation()
    Session.toggle 'target', @_id
    if Session.equals 'target', @_id
      Session.set 'type', 'user'
      #Router.navigate @profile.username, false
    else
      Session.set 'type', null

  'click .nav': (e) ->
    e.stopImmediatePropagation()

Template.userBanner.helpers
  selected: -> 
    Session.equals 'target', @_id

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

  numVotes: ->
    Votes.find(user: @_id).count()

  numFavs: ->
    Favourites.find(user: @_id).count()

  numAccomplishments: ->
    Accomplishments.find(user: @_id).count()

  numComments: ->
    Comments.find(user: @_id).count()

  numAchievements: ->
    Achievements.find(user: @_id).count()