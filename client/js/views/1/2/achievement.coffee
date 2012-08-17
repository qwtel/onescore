_.extend Template.achievement, Template.vote,
  events:
    #'click .vote': (e) ->
    #  unless e.isPropagationStopped()
    #    $t = $(e.target)
    #    unless $t.hasClass 'vote' then $t = $t.parents '.vote'
    #    up = $t.data 'up'
    #    Meteor.call 'vote', 'achievements', @_id, up
    #    e.stopPropagation()

    'click .expand': (e) ->
      unless e.isPropagationStopped()
        Session.toggle 'expand', @_id
        e.stopPropagation()

    'click .fav': (e) ->
      fav = Favourites.findOne
        user: Meteor.user()._id
        entity: @_id

      if fav
        Favourites.update fav._id,
          $set:
            active: !fav.active
      else
        Favourites.insert
          user: Meteor.user()._id
          entity: @_id
          active: true

  faved: ->
    if Meteor.user()
      fav = Favourites.findOne
        user: Meteor.user()._id
        entity: @_id
        active: true
      if fav
        return 'active'
    return ''

  #voted: (state) ->
  #  state = if state is 'up' then true else false
  #
  #  if Meteor.user()
  #    vote = Votes.findOne
  #      user: Meteor.user()._id
  #      entity: @_id
  #    if vote and vote.up is state
  #      return 'active'
  #  return ''

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
    if this
      if @score?
        return true
      else
        return false

_.extend Template.achievement.events, Template.vote.events
