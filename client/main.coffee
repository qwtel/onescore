Router = new Router

Meteor.startup ->
  Session.set 'scope', 'all'

  Backbone.history.start pushState: true

  Accounts.ui.config
    requestPermissions:
      facebook: [
        "user_about_me"
        "user_location"
      ]
