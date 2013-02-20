Template.ladder.events

Template.ladder.helpers
  users: ->
    Meteor.users.find {},
      sort: 'profile.xp': -1
