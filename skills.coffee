# TODO: move hard-coded text into strings.coffee
Skills = new Meteor.Collection null
Skills.insert
  _id: 'home'
  icon: 'home'
  url: 'home'
  name: strings 'home'
  description: strings 'homeDesc'
  active: -> Session.equals 'page', 'home'
  level: 1
  usable: true
  nav: true

Skills.insert
  _id: 'notifications'
  icon: 'globe'
  url: 'notifications'
  name: strings 'notifications'
  description: strings 'notificationDesc' 
  active: -> Session.equals 'page', 'notifications'
  level: 99
  usable: true
  nav: true

Skills.insert
  _id: 'explore'
  url: 'explore'
  icon: 'road'
  name: strings 'explore'
  description: strings 'exploreDesc'
  active: -> Session.equals 'page', 'explore'
  level: 1
  usable: true
  nav: true

Skills.insert
  _id: 'ladder'
  url: 'ladder'
  icon: 'th-list'
  name: strings 'ladder'
  description: strings 'ladderDesc'
  active: -> Session.equals 'page', 'ladder'
  level: 4
  usable: true
  nav: true

Skills.insert
  _id: 'profile'
  url: -> Meteor.user().profile.username
  icon: 'user'
  name: strings 'profile'
  description: strings 'profileDesc'
  active: -> 
    if Session.equals('page', 'profile') and 
      not Session.equals('menu', 'questlog') then 'active' else ''
  level: 1
  usable: true
  nav: true

Skills.insert
  _id: 'questlog'
  url: -> Meteor.user().profile.username+'/questlog'
  icon: 'star'
  name: strings 'questlog'
  description: strings 'questlogDesc'
  active: -> 
    if Session.equals('page', 'profile') and
      Session.equals('menu', 'questlog') then 'active' else ''
  level: 3
  usable: true
  nav: true

Skills.insert
  _id: 'newAchievement'
  icon: 'plus'
  name: strings 'newAchievement'
  description: strings 'newAchievementDesc' 
  cooldown: 10
  level: 1
  usable: true
  active: -> 
    Session.equals 'page', 'newAchievement'
  url: -> 
    id = Session.get 'target'
    type = Session.get 'type'
    if id and type is 'achievement'
      return "achievement/#{id}/new"
    else
      return "achievement/new"

Skills.insert
  _id: 'voteUp'
  name: 'Vote Up'
  icon: 'arrow-up'
  passive: true
  description: 'Allows you to vote for content'
  cooldown: 1
  level: 1
  usable: -> !Session.equals 'type', null
  click: ->
    id = Session.get 'target'
    type = Session.get 'type'
    Meteor.call 'voteUp', id, type
  active: ->
    id = Session.get 'target'
    user = Meteor.user()
    if user and id then isUpVoted(id, user._id)

Skills.insert
  _id: 'voteDown'
  name: 'Vote Down'
  icon: 'arrow-down'
  passive: true
  description: 'Allows you to vote for content'
  cooldown: 1
  level: 1
  usable: -> !Session.equals 'type', null
  click: ->
    id = Session.get 'target'
    type = Session.get 'type'
    Meteor.call 'voteDown', id, type
  active: ->
    id = Session.get 'target'
    user = Meteor.user()
    if user and id then isDownVoted(id, user._id)

Skills.insert
  _id: 'favourite'
  icon: 'star'
  passive: true
  name: strings 'accept'
  description: strings 'acceptDesc' 
  cooldown: 1
  level: 1
  usable: -> Session.equals 'type', 'achievement'
  click: ->
    id = Session.get 'target'
    Meteor.call 'favourite', entity: id
  active: -> 
    id = Session.get 'target'
    user = Meteor.user()
    if user and id then isActiveInCollection(Favourites, id, user._id)

Skills.insert
  _id: 'accomplish'
  icon: 'certificate'
  passive: true
  name: strings 'accomplish'
  description: strings 'accomplishDesc'
  cooldown: 10
  level: 1
  usable: -> Session.equals 'type', 'achievement'
  click: ->
    id = Session.get 'target'
    Meteor.call 'accomplish', entity: id, (error, result) ->
      Router.navigate "/accomplishment/#{result}", true
  active: ->
    id = Session.get 'target'
    user = Meteor.user()
    if user and id then isActiveInCollection(Accomplishments, id, user._id)

Skills.insert
  _id: 'comment'
  name: 'Comment'
  icon: 'comment'
  passive: true
  description: 'Allows you to comment on content'
  cooldown: 5
  level: 5

Skills.insert
  _id: 'tag'
  name: 'Tag'
  icon: 'tag'
  passive: true
  description: 'Allows you to tag content'
  cooldown: 1
  level: 6

Skills.insert
  _id: 'edit'
  name: 'Edit'
  icon: 'pencil'
  passive: true
  description: 'Allows you to edit achievements'
  cooldown: 1
  level: 7

Skills.insert
  _id: 'revision'
  name: 'Revision'
  icon: 'time'
  passive: true
  description: 'Allows you to revision achievements'
  cooldown: 1
  level: 8

isActiveInCollection = (collection, id, userId) ->
  exists = collection.findOne
    user: userId
    entity: id
    active: true
  return exists?

isUpVoted = (id, userId) ->
  exists = Votes.findOne
    user: userId
    entity: id
    active: true
  return exists?

isDownVoted = (id, userId) ->
  exists = Votes.findOne
    user: userId
    entity: id
    active: false
  return exists?
