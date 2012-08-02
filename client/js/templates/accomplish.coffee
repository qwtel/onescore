_.extend Template.accomplish,
  events:
    'click .create': (e) ->
      stry = $("#accomplish-#{@_id}").val()
      Meteor.call 'accomplish', @_id, stry
      Session.set 'expand', null

  accomplishment: ->
    return Accomplishments.findOne
      user: Meteor.user()._id
      entity: @_id

