Comments = new Meteor.Collection 'comments'
Achievements = new Meteor.Collection 'achievements'
Titles = new Meteor.Collection 'titles'
Votes = new Meteor.Collection 'votes'
Favourites = new Meteor.Collection 'favourites'
Accomplishments = new Meteor.Collection 'accomplishments'
Notifications = new Meteor.Collection 'notifications'
Revisions = new Meteor.Collection 'revisions'

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
  'revisions': Revisions
  'revision': Revisions

Scratchpad = new Meteor.Collection(null)
Collections['scratchpad'] = Scratchpad

Skills = new Meteor.Collection 'skills'
Skills.remove {}
Skills.insert
  name: 'Home'
  icon: 'home'
  url: 'home'
  description: 'View success stories of other players'
  active: -> window.isActive 'page', 'home'
  level: 1

Skills.insert
  name: 'Notifications'
  icon: 'globe'
  url: 'notifications'
  description: 'See how other users interact with your content'
  active: -> window.isActive 'page', 'notifications'
  level: 1

Skills.insert
  name: 'Explore'
  url: 'explore'
  icon: 'road'
  description: 'Allows you to find achievements'
  active: -> window.isActive 'page', 'explore'
  level: 1

Skills.insert
  name: 'Ladder'
  url: 'ladder'
  icon: 'th-list'
  description: 'Compete with other players based on your score'
  active: -> window.isActive 'page', 'ladder'
  level: 4

Skills.insert
  name: 'Profile'
  url: -> Meteor.user().username
  icon: 'user'
  description: 'Check out your recent activity'
  active: -> if Session.equals('page', 'profile') and
    not Session.equals('menu', 'questlog') then 'active' else ''
  level: 2

Skills.insert
  name: 'Quest Log'
  icon: 'glass'
  url: -> Meteor.user().username+'/questlog'
  description: 'Keept track of achievements you want to complete'
  active: -> if Session.equals('page', 'profile') and
    Session.equals('menu', 'questlog') then 'active' else ''
  level: 3

Skills.insert
  name: 'New achievement'
  icon: 'certificate'
  url: 'achievements/new'
  description: 'Create a new achievement'
  cooldown: 30
  active: -> window.isActive 'page', 'newAchievement'
  level: 5

Skills.insert
  name: 'Accept'
  icon: 'star'
  url: '#'
  passive: true
  description: 'Allows you to add achievements to your quest log'
  cooldown: 1
  level: 3

Skills.insert
  name: 'Vote'
  icon: 'arrow-up'
  url: '#'
  passive: true
  description: 'Allows you to vote for content'
  cooldown: 1
  level: 5

Skills.insert
  name: 'Comment'
  icon: 'comment'
  url: '#'
  passive: true
  description: 'Allows you to comment on content'
  cooldown: 5
  level: 5

Skills.insert
  name: 'Accomplish'
  icon: 'flag'
  url: '#'
  passive: true
  description: 'Gives you the ability to accomplish achievements'
  cooldown: 30
  level: 1

Skills.insert
  name: 'Tag'
  icon: 'tag'
  url: '#'
  passive: true
  description: 'Allows you to tag content'
  cooldown: 1
  level: 6
