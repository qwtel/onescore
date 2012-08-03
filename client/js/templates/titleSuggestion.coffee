_.extend Template.titleSuggestions,
  events:
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

      achievementId = Session.get 'expand'
      Meteor.call 'updateTitleScore', @_id, achievementId

  titles: ->
    id = Session.get 'expand'
    titles = Titles.find
      entity: id
      user: Meteor.user()._id
    ,
      sort:
        score: -1

    return titles

  voted: (state) ->
    state = if state is "up" then true else false

    vote = Votes.findOne
      user: Meteor.user()._id
      entity: @_id
    if vote and vote.up is state
      return 'active'
    return ''

