Skills = new Meteor.Collection 'skills'
Skills.remove {}
Skills.insert
  id: 'home'
  name: 'Home'
  icon: 'home'
  url: 'home'
  description: 'View success stories of other players'
  active: -> window.isActive 'page', 'home'
  level: 1

Skills.insert
  id: 'notifications'
  name: 'Notifications'
  icon: 'globe'
  url: 'notifications'
  description: 'See how other users interact with your content'
  active: -> window.isActive 'page', 'notifications'
  level: 2

Skills.insert
  id: 'explore'
  name: 'Explore'
  url: 'explore'
  icon: 'road'
  description: 'Allows you to find achievements'
  active: -> window.isActive 'page', 'explore'
  level: 1

Skills.insert
  id: 'ladder'
  name: 'Ladder'
  url: 'ladder'
  icon: 'th-list'
  description: 'Compete with other players based on your score'
  active: -> window.isActive 'page', 'ladder'
  level: 4

Skills.insert
  id: 'profile'
  name: 'Profile'
  url: -> Meteor.user().username
  icon: 'user'
  description: 'Check out your recent activity'
  active: -> if Session.equals('page', 'profile') and
    not Session.equals('menu', 'questlog') then 'active' else ''
  level: 1

Skills.insert
  name: 'Quest Log'
  icon: 'glass'
  url: -> Meteor.user().username+'/questlog'
  description: 'Keept track of achievements you want to complete'
  active: -> if Session.equals('page', 'profile') and
    Session.equals('menu', 'questlog') then 'active' else ''
  level: 3

Skills.insert
  id: 'newAchievement'
  name: 'New achievement'
  icon: 'certificate'
  url: 'achievements/new'
  description: 'Create a new achievement'
  cooldown: 30
  active: -> window.isActive 'page', 'newAchievement'
  level: 5

Skills.insert
  id: 'favourite'
  name: 'Accept'
  icon: 'star'
  url: '#'
  passive: true
  description: 'Allows you to add achievements to your quest log'
  cooldown: 1
  level: 3

Skills.insert
  id: 'vote'
  name: 'Vote'
  icon: 'arrow-up'
  url: '#'
  passive: true
  description: 'Allows you to vote for content'
  cooldown: 1
  level: 5

Skills.insert
  id: 'comment'
  name: 'Comment'
  icon: 'comment'
  url: '#'
  passive: true
  description: 'Allows you to comment on content'
  cooldown: 5
  level: 5

Skills.insert
  id: 'accomplish'
  name: 'Accomplish'
  icon: 'flag'
  url: '#'
  passive: true
  description: 'Gives you the ability to accomplish achievements'
  cooldown: 30
  level: 1

Skills.insert
  id: 'tag'
  name: 'Tag'
  icon: 'tag'
  url: '#'
  passive: true
  description: 'Allows you to tag content'
  cooldown: 1
  level: 6

Skills.insert
  id: 'edit'
  name: 'Edit'
  icon: 'pencil'
  url: '#'
  passive: true
  description: 'Allows you to edit achievements'
  cooldown: 1
  level: 7

Skills.insert
  id: 'revision'
  name: 'Revision'
  icon: 'time'
  url: '#'
  passive: true
  description: 'Allows you to revision achievements'
  cooldown: 1
  level: 8
