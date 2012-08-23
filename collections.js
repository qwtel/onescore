var
Comments = new Meteor.Collection('comments'),
Achievements = new Meteor.Collection('achievements'),
Activities = new Meteor.Collection('activities'),
Titles = new Meteor.Collection('titles'),

Votes = new Meteor.Collection('votes'),
Favourites = new Meteor.Collection('favourites'),
Quests = new Meteor.Collection('quests'),
Accomplishments = new Meteor.Collection('accomplishments'),

Notifications = new Meteor.Collection('notifications');

Collections = {
  'achievements': Achievements,
  'achievement': Achievements,
  'explore': Achievements,
  'accomplishments': Accomplishments,
  'accomplishment': Accomplishments,
  'home': Accomplishments,
  'profile': Accomplishments,
  'titles': Titles,
  'title': Titles,
  'votes': Votes,
  'vote': Votes,
  'comments': Comments,
  'comment': Comments
}
