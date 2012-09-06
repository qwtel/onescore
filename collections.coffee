Comments = new Meteor.Collection 'comments'
Achievements = new Meteor.Collection 'achievements'
Titles = new Meteor.Collection 'titles'

Votes = new Meteor.Collection 'votes'
Favourites = new Meteor.Collection 'favourites'
Accomplishments = new Meteor.Collection 'accomplishments'

Notifications = new Meteor.Collection 'notifications'

Collections = Collections or {}
_.extend Collections,
  'achievements': Achievements
  'achievement': Achievements
  'explore': Achievements
  'accomplishments': Accomplishments
  'accomplishment': Accomplishments
  'home': Accomplishments
  'profile': Accomplishments
  'titles': Titles
  'title': Titles
  'votes': Votes
  'vote': Votes
  'comments': Comments
  'comment': Comments

Scratchpad = new Meteor.Collection null
Collections['scratchpad'] = Scratchpad