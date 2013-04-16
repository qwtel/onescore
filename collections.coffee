root = exports ? this

root.Comments = new Meteor.Collection 'comments'
root.Achievements = new Meteor.Collection 'achievements'
root.Titles = new Meteor.Collection 'titles'
root.Votes = new Meteor.Collection 'votes'
root.Favourites = new Meteor.Collection 'favourites'
root.Accomplishments = new Meteor.Collection 'accomplishments'
root.Notifications = new Meteor.Collection 'notifications'
root.Revisions = new Meteor.Collection 'revisions'
root.Tags = new Meteor.Collection 'tags'
root.Scratchpad = new Meteor.Collection null

root.Collections = root.Collections or {}
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
