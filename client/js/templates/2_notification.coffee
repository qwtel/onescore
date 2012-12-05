_.extend Template.notification,
  user: ->
    Meteor.users.findOne @user

  isTitle: (type) ->
    type is 'title'

  title: ->
    t = Titles.findOne @target
    if t then t.title

  vote: (type) ->
    type is 'vote'

  accomplishment: (type) ->
    type is 'accomplishment'

  comment: (type) ->
    type is 'comment'

  reply: (type) ->
    type is 'comment'

  isRevision: (type) ->
    type is 'revision'

  your: ->
    c = Collections[@targetType].findOne @target
    if c and c.user is Meteor.user()._id
      return 'your'
    return ''
