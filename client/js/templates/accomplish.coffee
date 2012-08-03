_.extend Template.accomplish,
  events:
    'click .create': (e) ->
      stry = $("#accomplish-#{@_id}").val()
      Meteor.call 'accomplish', @_id, stry
      Session.set 'expand', null

    'click .text': (e) ->
      Session.toggle 'story', 'text'

    'click .picture': (e) ->
      Session.toggle 'story', 'picture'

    'click .link': (e) ->
      Session.toggle 'story', 'link'

  accomplishment: ->
    return Accomplishments.findOne
      user: Meteor.user()._id
      entity: @_id

