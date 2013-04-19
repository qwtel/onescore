Template.notification.events
  'click .btn, click .usr': (e) ->
    if @_id isnt Session.get('target')
      e.stopImmediatePropagation()
      clickPill this, e

Template.notification.helpers
  user: ->
    Meteor.users.findOne @user

  targetUser: ->
    Meteor.users.findOne @targetUser

  type: (type, name) ->
    type is name

  entityObject: ->
    _id: @entity
    type: @entityType
    user: @user

  targetEntityObject: ->
    _id: @target
    type: @targetType
    user: @user

