root = exports ? this
root.Skills = new Meteor.Collection null

Skills.insert
  _id: 'home'
  icon: 'home'
  url: 'home'
  name: strings 'home'
  description: strings 'homeDesc'
  active: -> Session.equals 'page', 'home'
  level: 1
  usable: -> true
  nav: true

Skills.insert
  _id: 'notifications'
  icon: 'globe'
  url: 'notification'
  name: strings 'notifications'
  description: strings 'notificationDesc' 
  active: -> Session.equals 'page', 'notification'
  level: 4
  usable: -> true
  nav: true

Skills.insert
  _id: 'explore'
  url: 'explore'
  icon: 'road'
  name: strings 'explore'
  description: strings 'exploreDesc'
  active: -> Session.equals 'page', 'explore'
  level: 1
  usable: -> true
  nav: true

Skills.insert
  _id: 'ladder'
  url: 'ladder'
  icon: 'th-list'
  name: strings 'ladder'
  description: strings 'ladderDesc'
  active: -> Session.equals 'page', 'ladder'
  level: 5
  usable: -> true
  nav: true

Skills.insert
  _id: 'user'
  url: -> "user/#{Meteor.userId()}/unlocks"
  icon: 'user'
  name: strings 'profile'
  description: strings 'profileDesc'
  active: -> Session.equals('page', 'user')
  level: 1
  usable: -> true
  nav: true

Skills.insert
  _id: 'questlog'
  url: -> "user/#{Meteor.userId()}/questlog"
  icon: 'star'
  name: strings 'questlog'
  description: strings 'questlogDesc'
  active: -> Session.equals('page', 'user') and Session.equals('tab-user', 'questlog')
  level: 5
  usable: -> false
  nav: false

Skills.insert
  _id: 'newAchievement'
  icon: 'file'
  name: strings 'newAchievement'
  description: strings 'newAchievementDesc' 
  cooldown: 5
  level: 1 #4
  usable: -> false
  active: false
  passive: true
  nav: true
  #url: "achievement/new"

Skills.insert
  _id: 'voteUp'
  name: 'Vote Up'
  icon: 'arrow-up'
  passive: true
  description: 'Allows you to vote for content'
  cooldown: 1
  level: 3
  usable: (id, type) -> type? and type isnt 'user' and id?
  click: (id, type) ->
    Meteor.call 'voteUp', id, type
  active: (id) ->
    user = Meteor.user()
    if user and id then isUpVoted id, user._id
  num: (entity) -> entity.upVotes


Skills.insert
  _id: 'voteDown'
  name: 'Vote Down'
  icon: 'arrow-down'
  passive: true
  description: 'Allows you to vote for content'
  cooldown: 1
  level: 6
  usable: (id, type) -> type? and type isnt 'user' and id?
  click: (id, type) ->
    Meteor.call 'voteDown', id, type
  active: (id) ->
    user = Meteor.user()
    if user and id then isDownVoted id, user._id
  num: (entity) -> entity.votes - entity.upVotes

Skills.insert
  _id: 'replyAchievement'
  icon: 'share-alt'
  name: strings 'replyAchievement'
  description: strings 'replyAchievementDesc' 
  cooldown: 5
  level: 999
  usable: (id, type) -> type is 'achievement'
  #url: -> 
  #  id = Session.get 'target'
  #  type = Session.get 'type'
  #  if id and type is 'achievement'
  #    return "achievement/#{id}/new"
  #  else
  #    return "achievement/new"
  click: (id, type) ->
    Session.set "reply", id
  active: (id) ->
    Session.equals "reply", id


Skills.insert
  _id: 'comment'
  name: 'Comment'
  icon: 'comment'
  passive: true
  description: 'Allows you to comment on content'
  cooldown: 10
  level: 4
  usable: (id, type) -> 
    if type? and id?
      unless type is 'user'
        return true
    return false
  click: (id, type) ->
    if Session.equals("comment", id)
      Session.set "comment", null
    else
      Session.set "comment", id
      Meteor.flush()
      $(".comment-#{id}").first().focus()
  active: (id) ->
    Session.equals "comment", id
  num: (entity) -> entity.comments

Skills.insert
  _id: 'favourite'
  icon: 'star'
  passive: true
  name: strings 'accept'
  description: strings 'acceptDesc' 
  cooldown: 1
  level: 5
  usable: (id, type) -> type is 'achievement'
  click: (id, type) ->
    Meteor.call 'favourite', id
  active: (id) ->
    user = Meteor.user()
    if user and id then isActiveInCollection Favourites, id, user._id
  num: (entity) -> entity.favourites

Skills.insert
  _id: 'accomplish'
  icon: 'lock'
  passive: true
  name: strings 'accomplish'
  description: strings 'accomplishDesc'
  cooldown: 1
  level: 1
  usable: (id, type) -> type is 'achievement'
  click: (id, type) ->
    Meteor.call 'accomplish', id, null, (error, res) ->
      if res is true
        Session.set "accomplished", id
        Meteor.flush()
        $(".accomplished-#{id}").first().focus()
  num: (entity) -> entity.accomplishments

  active: (id) ->
    user = Meteor.user()
    if user and id then isActiveInCollection Accomplishments, id, user._id

Skills.insert
  _id: 'tag'
  name: 'Tag'
  icon: 'tag'
  passive: true
  description: 'Allows you to tag content'
  cooldown: 1
  level: 999

Skills.insert
  _id: 'revision'
  name: 'Revision'
  icon: 'time'
  passive: true
  description: 'Allows you to revision achievements'
  cooldown: 1
  level: 999

Skills.insert
  _id: 'inspect'
  icon: 'eye-open'
  name: strings 'inspect'
  description: strings 'inspectDesc' 
  level: 2
  active: (target) ->
    id = Session.get 'id'
    id? and target? and id is target
  usable: (id, type) -> id? and type?
  hasUrl: true
  url: (id, type) -> 
    if id and type then "#{type}/#{id}"

Skills.insert
  _id: 'edit'
  name: 'Edit'
  icon: 'pencil'
  passive: true
  description: 'Edit your current target.'
  cooldown: 10
  level: 4
  usable: (id, type) -> 
    if type? and id?
      entity = Collections[type].findOne id
      userId = Meteor.userId()
      if userId is entity.user
        return true
    return false
  click: (id, type) ->
    if Session.equals("edit", id)
      Session.set "edit", null
    else
      Session.set "edit", id
      Meteor.flush()
      $(".edit-#{id}").first().focus()
  active: (id) ->
    Session.equals "edit", id

Skills.insert
  _id: 'delete'
  name: 'Delete'
  icon: 'trash'
  passive: true
  description: 'Edit your current target.'
  cooldown: 10
  level: 4
  usable: (id, type) -> 
    if type? and id?
      entity = Collections[type].findOne id
      userId = Meteor.userId()
      if userId is entity.user
        return true
    return false
  click: (id, type) ->
    if Session.equals("delete", id)
      Session.set "delete", null
    else
      Session.set "delete", id
  active: (id) ->
    Session.equals "delete", id

root.isActiveInCollection = (collection, id, userId) ->
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
