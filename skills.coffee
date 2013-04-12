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
  url: 'notification'
  name: strings 'notifications'
  description: strings 'notificationDesc' 
  active: -> Session.equals 'page', 'notification'
  level: 4
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
  level: 5
  usable: true
  nav: true

Skills.insert
  _id: 'user'
  url: -> "user/#{Meteor.userId()}/unlocks"
  icon: 'user'
  name: strings 'profile'
  description: strings 'profileDesc'
  active: -> Session.equals('page', 'user') and (Session.equals('tab-user', 'unlocks') or Session.equals('tab-user', 'activity'))
  level: 1
  usable: true
  nav: true

Skills.insert
  _id: 'questlog'
  url: -> "user/#{Meteor.userId()}/questlog"
  icon: 'star'
  name: strings 'questlog'
  description: strings 'questlogDesc'
  active: -> Session.equals('page', 'user') and Session.equals('tab-user', 'questlog')
  level: 5
  usable: true
  nav: true

Skills.insert
  _id: 'newAchievement'
  icon: 'file'
  name: strings 'newAchievement'
  description: strings 'newAchievementDesc' 
  cooldown: 5
  level: 4
  usable: false
  active: false
  #url: "achievement/new"

Skills.insert
  _id: 'inspect'
  icon: 'eye-open'
  name: strings 'inspect'
  description: strings 'inspectDesc' 
  level: 2
  active: ->
    id = Session.get 'id'
    target = Session.get 'target'
    id? and target? and id is target
  usable: -> (Session.get 'target')?
  url: -> 
    id = Session.get 'target'
    type = Session.get 'type'
    if id and type then "#{type}/#{id}"

Skills.insert
  _id: 'voteUp'
  name: 'Vote Up'
  icon: 'arrow-up'
  passive: true
  description: 'Allows you to vote for content'
  cooldown: 1
  level: 3
  usable: -> (Session.get 'type')? and (Session.get 'target')?
  click: ->
    id = Session.get 'target'
    type = Session.get 'type'
    Meteor.call 'voteUp', id, type
  active: ->
    id = Session.get 'target'
    user = Meteor.user()
    if user and id then isUpVoted id, user._id

Skills.insert
  _id: 'voteDown'
  name: 'Vote Down'
  icon: 'arrow-down'
  passive: true
  description: 'Allows you to vote for content'
  cooldown: 1
  level: 6
  usable: -> (Session.get 'type')? and (Session.get 'target')?
  click: ->
    id = Session.get 'target'
    type = Session.get 'type'
    Meteor.call 'voteDown', id, type
  active: ->
    id = Session.get 'target'
    user = Meteor.user()
    if user and id then isDownVoted id, user._id

Skills.insert
  _id: 'replyAchievement'
  icon: 'share-alt'
  name: strings 'replyAchievement'
  description: strings 'replyAchievementDesc' 
  cooldown: 5
  level: 999
  usable: -> 
    Session.equals 'type', 'achievement'
  #url: -> 
  #  id = Session.get 'target'
  #  type = Session.get 'type'
  #  if id and type is 'achievement'
  #    return "achievement/#{id}/new"
  #  else
  #    return "achievement/new"
  click: ->
    id = Session.get 'target'
    Session.set "reply", id
  active: ->
    id = Session.get 'target'
    Session.equals "reply", id


Skills.insert
  _id: 'comment'
  name: 'Comment'
  icon: 'comment'
  passive: true
  description: 'Allows you to comment on content'
  cooldown: 10
  level: 4
  usable: -> 
    if (Session.get 'type')? and (Session.get 'target')?
      unless Session.get('type') is 'user'
        return true
    return false
  click: ->
    id = Session.get 'target'
    Session.set "comment", id
    Meteor.flush()
    $(".comment-#{id}").first().focus()
  active: ->
    id = Session.get 'target'
    Session.equals "comment", id

Skills.insert
  _id: 'favourite'
  icon: 'star'
  passive: true
  name: strings 'accept'
  description: strings 'acceptDesc' 
  cooldown: 1
  level: 5
  usable: -> Session.equals 'type', 'achievement'
  click: ->
    id = Session.get 'target'
    Meteor.call 'favourite', id
  active: -> 
    id = Session.get 'target'
    user = Meteor.user()
    if user and id then isActiveInCollection Favourites, id, user._id

Skills.insert
  _id: 'accomplish'
  icon: 'lock'
  passive: true
  name: strings 'accomplish'
  description: strings 'accomplishDesc'
  cooldown: 1
  level: 1
  usable: -> Session.equals 'type', 'achievement'
  click: ->
    id = Session.get 'target'
    Meteor.call 'accomplish', id, null, (error, res) ->
      if res is true
        Session.set "accomplished", id
        Meteor.flush()
        $(".accomplished-#{id}").first().focus()

  active: ->
    id = Session.get 'target'
    user = Meteor.user()
    if user and id then isActiveInCollection Accomplishments, id, user._id

Skills.insert
  _id: 'tag'
  name: 'Tag'
  icon: 'tag'
  passive: true
  description: 'Allows you to tag content'
  cooldown: 1
  level: 99

Skills.insert
  _id: 'edit'
  name: 'Edit'
  icon: 'pencil'
  passive: true
  description: 'Allows you to edit achievements'
  cooldown: 1
  level: 99

Skills.insert
  _id: 'revision'
  name: 'Revision'
  icon: 'time'
  passive: true
  description: 'Allows you to revision achievements'
  cooldown: 1
  level: 99

isActiveInCollection = (collection, id, userId) ->
  (collection.findOne
    user: userId
    entity: id
    active: true
  )?

isUpVoted = (id, userId) ->
  (Votes.findOne
    user: userId
    entity: id
    active: true
  )?

isDownVoted = (id, userId) ->
  (Votes.findOne
    user: userId
    entity: id
    active: false
  )?
