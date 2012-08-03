_.extend Template.achievement,
  events:
    'click .expand': (e) ->
      Session.toggle 'expand', @_id
      Session.set 'expandTab', 'info'

    'click .accomplish': (e) ->
      Session.set 'expand', @_id
      Session.toggle 'expandTab', 'accomplish'

    'click .edit': (e) ->
      Session.set 'expand', @_id
      Session.toggle 'expandTab', 'edit'

    'click .talk': (e) ->
      Session.set 'expand', @_id
      Session.toggle 'expandTab', 'talk'

    'click .vote': (e) ->
      unless e.isPropagationStopped()
        $t = $(e.target)
        unless $t.hasClass 'vote' then $t = $t.parents '.vote'
        up = $t.data 'up'
        Meteor.call 'vote', 'achievements', @_id, up
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

    'click .quest': (e) ->
      quest = Quests.findOne
        user: Meteor.user()._id
        entity: @_id

      if quest
        Quests.update quest._id,
          $set:
            active: !quest.active
      else
        Quests.insert
          user: Meteor.user()._id
          entity: @_id
          active: true

  expandTab: ->
    return Session.get 'expandTab'

  faved: ->
    if Meteor.user()
      fav = Favourites.findOne
        user: Meteor.user()._id
        entity: @_id
        active: true
      if fav
        return 'active'
    return ''

  quest: ->
    if Meteor.user()
      fav = Quests.findOne
        user: Meteor.user()._id
        entity: @_id
        active: true
      if fav
        return 'active'
    return ''

  voted: (state) ->
    state = if state is 'up' then true else false

    if Meteor.user()
      vote = Votes.findOne
        user: Meteor.user()._id
        entity: @_id
      if vote and vote.up is state
        return 'active'
    return ''

  completed: ->
    if Meteor.user()
      acc = Accomplishments.findOne
        user: Meteor.user()._id
        entity: @_id
      if acc
        return 'completed'
    return ''
