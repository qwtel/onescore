Comments = new Meteor.Collection 'comments'
Achievements = new Meteor.Collection 'achievements'
Titles = new Meteor.Collection 'titles'
Votes = new Meteor.Collection 'votes'
Favourites = new Meteor.Collection 'favourites'
Accomplishments = new Meteor.Collection 'accomplishments'
Notifications = new Meteor.Collection 'notifications'
Revisions = new Meteor.Collection 'revisions'
Tags = new Meteor.Collection 'tags'
Scratchpad = new Meteor.Collection null

Collections = Collections or {}
_.extend Collections,
  'user': Meteor.users
  'comment': Comments
  'achievement': Achievements
  'title': Titles
  'vote': Votes
  'favourite': Favourites
  'accomplishment': Accomplishments
  'notifiacation': Notifications
  'revision': Revisions
  'tag': Tags
  'scratchpad': Scratchpad
