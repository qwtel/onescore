_.extend Template.notification,
  user: ->
    Meteor.users.findOne @user

  title: ->
    @entityType is 'title'

  vote: ->
    @entityType is 'vote'

  accomplishment: ->
    @entityType is 'accomplishment'

  comment: ->
    @entityType is 'comment'

  reply: ->
    @targetType is 'comment'

  your: ->
    c = Collections[@targetType].findOne @target
    if c and c.user is Meteor.user()._id
      return 'your'
    return ''
