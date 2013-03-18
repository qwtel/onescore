Meteor.startup ->
  Meteor.users.allow
    insert: -> true
    update: -> true
    remove: -> true
  Comments.allow
    insert: -> true
    update: -> true
    remove: -> true
  Achievements.allow
    insert: -> true
    update: -> true
    remove: -> true
  Titles.allow
    insert: -> true
    update: -> true
    remove: -> true
  Votes.allow
    insert: -> true
    update: -> true
    remove: -> true
  Favourites.allow
    insert: -> true
    update: -> true
    remove: -> true
  Accomplishments.allow
    insert: -> true
    update: -> true
    remove: -> true
  Notifications.allow
    insert: -> true
    update: -> true
    remove: -> true
  Revisions.allow
    insert: -> true
    update: -> true
    remove: -> true
  Tags.allow
    insert: -> true
    update: -> true
    remove: -> true
