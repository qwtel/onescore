_.extend Template.userBanner,
  pic: ->
    user = Meteor.user()
    if user
      if user.services
        fbid = _.escape user.services.facebook.id
        return "<img src='https://graph.facebook.com/#{fbid}/picture&type=normal'/>"

