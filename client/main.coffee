root = exports ? this
root.Router = new Router

Meteor.startup ->
  Backbone.history.start pushState: true

  Meteor.call 'updateUserScore'

  Accounts.ui.config
    requestPermissions:
      facebook: [
        "user_about_me"
        "user_location"
      ]
