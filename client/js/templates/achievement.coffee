_.extend Template.achievement,
  events:
    'click .expand': (e) ->
      Session.set 'expand', @_id
      Session.toggle 'expandTab', 'info'

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
      $t = $(e.target).parents '.vote'
      data =
        user: Meteor.user()._id
        entity: @_id
        up: $t.data 'up'

      vote = Votes.findOne
        user: Meteor.user()._id
        entity: @_id

      if vote
        Votes.update vote._id,
          $set: data
      else
        Votes.insert data

      Meteor.call 'updateAchievementScore', @_id

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
