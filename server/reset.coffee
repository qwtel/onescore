Meteor.startup ->
#  Accounts.loginServiceConfiguration.remove({})
#  Meteor.users.remove({})
#  Comments.remove({})
#  Achievements.remove({})
#  Titles.remove({})
#  Votes.remove({})
#  Favourites.remove({})
#  Accomplishments.remove({})
#  Notifications.remove({})
#  Revisions.remove({})
#  Tags.remove({})
  Notifications.update {},
    $set:
      seen: []
    ,
      multi: true
