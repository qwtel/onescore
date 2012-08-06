_.extend Template.accomplish,
  events:
    'click .create': (e) ->
      stry = $("#accomplish-#{@_id}").val()
      Session.set 'expand', null
      Meteor.call 'accomplish', @_id, stry

    'click .uncreate': (e) ->
      Accomplishments.remove @_id

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

