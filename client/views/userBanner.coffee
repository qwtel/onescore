Template.userBanner.events
  #'click .pill': (e) ->
  #  e.stopImmediatePropagation()
  #  clickPill this, e

  'click .nav': (e) ->
    e.stopImmediatePropagation()

Template.userBanner.helpers
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
