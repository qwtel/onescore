_.extend Template.userBanner,
  events:
    'click .refresh': (e) ->
      Meteor.call 'updateUserScoreComplete'

  user: ->
    username = Session.get 'username'
    if username
      return Meteor.users.findOne
        username: username

  pic: ->
    username = Session.get 'username'
    if username
      return "<img src='https://graph.facebook.com/#{username}/picture?type=normal'/>"

