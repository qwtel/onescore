Template.protoAccomplishment.events
  'click .usr, click .media-heading a': (e) ->
    e.stopImmediatePropagation()
    clickPill this, e

Template.protoAccomplishment.helpers
  user: -> Meteor.users.findOne _id: @user

