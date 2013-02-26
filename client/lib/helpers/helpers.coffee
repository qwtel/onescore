Handlebars.registerHelper 'session', (name) ->
  Session.get name

Handlebars.registerHelper 'show', (name) ->
  Session.equals name, true

Handlebars.registerHelper 'equals', (name, value) ->
  Session.equals name, value

Handlebars.registerHelper 'strings', (id) ->
  (Strings.findOne id).string

Handlebars.registerHelper 'hasLevel', (level) ->
  user = Meteor.user()
  if user and user.profile
    return user.profile.level >= level

Handlebars.registerHelper 'username', (id) ->
  Meteor.users.findOne(id).profile.username

Handlebars.registerHelper 'timeago', (date) ->
  d = moment(new Date(date))
  d.fromNow()

Session.toggle = (name, value) ->
  if value?
    if Session.equals name, value
      Session.set name, null
    else
      Session.set name, value
  else
    Session.set name, !Session.get(name)

color = ->
  user = Meteor.user()
  if user
    userId = user._id
    if isActiveInCollection Accomplishments, @_id, userId
      return 'completed'
    if isActiveInCollection Favourites, @_id, userId
      return 'accepted'
    else if Achievements.find().count() > 0
      return 'uncompleted'

clickPill = (entity) ->
  target = Session.get 'target'
  if target is entity._id
    Session.set 'target', null
    Session.set 'type', null
    Session.set "target-#{entity._id}", false
  else
    Session.set 'target', entity._id
    Session.set 'type', if entity.type? then entity.type else 'user' # XXX
    Session.set "target-#{entity._id}", true
