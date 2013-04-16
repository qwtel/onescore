Template.doneThat.events
  'click .btn': (e) ->
    Meteor.call 'accomplish', @_id, null, (error, res) =>
      if res is true
        Session.set "accomplished", @_id
        Meteor.flush()
        $(".accomplished-#{@_id}").first().focus()

Template.doneThat.helpers
