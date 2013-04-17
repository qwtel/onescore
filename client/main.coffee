root = exports ? this
root.Router = new Router

Meteor.startup ->
  Backbone.history.start pushState: true

  Meteor.call 'updateUserScore'

  savePosition = _.throttle ->
    page = Session.get 'page'
    scroll = $(document).scrollTop
    Session.set "#{page}/scroll", scroll
  ,
    250

  $(window).scroll(savePosition);

  Accounts.ui.config
    requestPermissions:
      facebook: [
        "user_about_me"
        "user_location"
      ]
