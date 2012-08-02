_.extend Template.accomplish,
  events:
    'click .create': (e) ->
      stry = $("#accomplish-#{@_id}").val()

      acc = Accomplishments.findOne
        user: Meteor.user()._id
        entity: @_id

      if acc
        Accomplishments.update acc._id,
          $set:
            story: stry
      else
        Accomplishments.insert
          user: Meteor.user()._id
          entity: @_id
          story: stry

      Session.set 'expand', null

  accomplishment: ->
    return Accomplishments.findOne
      user: Meteor.user()._id
      entity: @_id

