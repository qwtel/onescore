_.extend Template.achievement,
  events:
    'click .vote': (e) ->
      unless e.isPropagationStopped()
        $t = $(e.target)
        unless $t.hasClass 'vote' then $t = $t.parents '.vote'
        up = $t.data 'up'
        Meteor.call 'vote', 'achievements', @_id, up
        e.stopPropagation()

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

    #'click .quest': (e) ->
    #  quest = Quests.findOne
    #    user: Meteor.user()._id
    #    entity: @_id
    #
    #  if quest
    #    Quests.update quest._id,
    #      $set:
    #        active: !quest.active
    #  else
    #    Quests.insert
    #      user: Meteor.user()._id
    #      entity: @_id
    #      active: true

  faved: ->
    if Meteor.user()
      fav = Favourites.findOne
        user: Meteor.user()._id
        entity: @_id
        active: true
      if fav
        return 'active'
    return ''

  #quest: ->
  #  if Meteor.user()
  #    fav = Quests.findOne
  #      user: Meteor.user()._id
  #      entity: @_id
  #      active: true
  #    if fav
  #      return 'active'
  #  return ''

  voted: (state) ->
    state = if state is 'up' then true else false

    if Meteor.user()
      vote = Votes.findOne
        user: Meteor.user()._id
        entity: @_id
      if vote and vote.up is state
        return 'active'
    return ''

  color: ->
    if this
      if Session.equals 'newAchievement', @_id
        return ''

    if Meteor.user()
      acc = Accomplishments.findOne
        user: Meteor.user()._id
        entity: @_id
      if acc
        return 'completed'

      fav = Favourites.findOne
        user: Meteor.user()._id
        entity: @_id
        active: true
      if fav
        return 'accepted'

      else if Session.get 'accomplishmentsLoaded'
        return 'uncompleted'

      return ''

  hasScore: ->
    if this
      if @score?
        return true
      else
        return false
