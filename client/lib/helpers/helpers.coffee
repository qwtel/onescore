root = exports ? this

Handlebars.registerHelper 'session', (name) ->
  Session.get name

Handlebars.registerHelper 'typeName', ->
  if @type
    strings @type
  else
    strings 'entity'

Handlebars.registerHelper 'show', (name) ->
  Session.equals name, true

Handlebars.registerHelper 'equals', (name, value) ->
  Session.equals name, value

Handlebars.registerHelper 'strings', (id) ->
  (Strings.findOne id).string

Handlebars.registerHelper 'hasLevel', (skill) ->
  skill = Skills.findOne skill
  user = Meteor.user()
  if user and user.profile
    return user.profile.level >= skill.level

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

Handlebars.registerHelper 'selected', ->
  Session.equals "selected-#{@_id}", true

Handlebars.registerHelper 'color', ->
  user = Meteor.user()
  switch @type
    when 'achievement'
      if user?
        userId = user._id
        if isActiveInCollection Accomplishments, @_id, userId
          return 'completed'
        else if isActiveInCollection Favourites, @_id, userId
          return 'accepted'
        else
          return 'uncompleted'
      else
        return 'uncompleted'

    when 'accomplishment'
      if user?
        userId = user._id
        if userId == @user
          return 'completed'

    when 'comment'
      if user?
        userId = user._id
        if userId == @user
          return 'completed'

    else
      if user? and user.profile?
        if user.profile.username == @profile.username
          return 'completed'
      return ''

root.clickPill = (entity, e) ->
  target = Session.get 'target'
  type = Session.get 'type'
  Session.set "selected-#{target}", false

  if target is entity._id
    Session.set 'target', null
    Session.set 'type', null
    Session.set "target-#{entity._id}", false
    Session.set "comment", null
    Session.set "accomplished", null

    if $(e.currentTarget).parents('.afx').length is 0
      Session.set "temp", null

  else
    typeHack = if entity.type? then entity.type else 'user' #XXX
    #Router.navigate "/#{typeHack}/#{entity._id}", false

    Session.set "selected-#{entity._id}", true
    Session.set 'target', entity._id
    Session.set 'type', typeHack
    Session.set "target-#{entity._id}", true

    if $(e.currentTarget).parents('.afx').length is 0
      Session.set 'temp', entity._id
