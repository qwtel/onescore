Template.doneThat.events
  'click .btn': (e) ->
    id = $(e.currentTarget).data 'hack'
    Meteor.call 'accomplish', id, null

Template.doneThat.helpers
  skill: ->
    Skills.findOne 'accomplish'
