window.items = [
    name: 'Home'
  ,
    name: 'Explore'
  ,
    name: 'Ladder'
]

window.categories = [
    name: 'Carrier'
  ,
    name: 'Education'
  ,
    name: 'Health'
  ,
    name: 'Meta'
  ,
    name: 'Random'
  ,
    name: 'Sports'
]

Session.toggle = (name, value) ->
  if value?
    if Session.equals name, value
      Session.set name, null
    else
      Session.set name, value
  else
    Session.set name, !Session.get(name)

window.createNewAchievement = ->
  if Meteor.user()
    newAchievement = Achievements.findOne
      user: Meteor.user()._id
      created: false

    if newAchievement
      id = newAchievement._id
    else
      id = Achievements.insert
        user: Meteor.user()._id
        score: 0
        created: false

    return id

window.makeOkCancelHandler = (options) ->
  ok = options.ok || ->
  cancel = options.cancel || ->

  return (evt) ->
    if evt.type is "keydown" and evt.which is 27
      cancel.call this, evt

    else if evt.type is "keyup" and evt.which is 13
      value = String(evt.target.value or "")
      if value
        ok.call this, value, evt
      else
        cancel.call this, evt

window.getThreadId = (comment) ->
  while comment.parent isnt null
    comment = Comments.findOne comment.parent
  return comment._id

window.focusById = (id) ->
  #$t = $('#'+id)
  #t = $t.val()
  #$t.focus().val('').val(t)
  $('#'+id).focus()#.select()

window.findTags = (text) ->
  pattern = /// [^&]\B(#(\w\w+)) ///g
  text = _.escape text

  tags = []
  while match = pattern.exec(text)
    tags.push match[2]

  return tags

window.wrapTags = (text) ->
  if text
    pattern = /// [^&]\B(#(\w\w+)) ///g
    text = _.escape text
    return text.replace pattern, ' <a class="tag" data-tag="$2">$1</a>'
  return ''

$.fn.clear = ->
  $(this).val ''

window.positionActivityModal = ($modal, id) ->
  if id?
    p = $('#activity-'+id).offset()

  if not id? or not p?
    p = {}
    p.top = 50

  $modal.modal(keyboard: false, show: true).offset(top: p.top)
    .on 'hide', ->
      $('body').height('auto')
      window.Router.navigate 'activities', true

  $('body').height($('body').height() + $(window).height())
  $(document).scrollTop(p.top - 50)

window.getUsername = (userId) ->
  user = Ushers.findOne userId
  if user
    return user.name
  return ''

Session.toggle = (name, value) ->
  if value?
    if Session.equals name, value
      Session.set name, null
    else
      Session.set name, value
  else
    Session.set name, !Session.get(name)

Session.push = (name, key, value) ->
  field = Session.get name
  unless field
    field = {}
    Session.set name, field

  if field[key] is value
    field[key] = null
  else
    field[key] = value

  Session.toggle 'redraw', true

Handlebars.registerHelper 'session', (name) ->
  return Session.get name

Handlebars.registerHelper 'show', (name) ->
  return Session.equals name, true

Handlebars.registerHelper 'equals', (name, value) ->
  return Session.equals name, value

Handlebars.registerHelper 'isActive', (name, value) ->
  return if Session.equals(name, value) then 'active' else ''

Handlebars.registerHelper 'belongsTo', (user) ->
  return Meteor.user()._id is user._id

Handlebars.registerHelper 'isMe', (user) ->
  if user
    return if Meteor.user()._id is user._id then 'my' else ''

Handlebars.registerHelper 'userIn', (field) ->
  if field?
    return Session.get('user') in field
  return false

Handlebars.registerHelper 'activity', ->
  activityId = Session.get 'activity'
  activity = Activities.findOne activityId
  return activity or {}

Handlebars.registerHelper 'wrapTags', window.wrapTags

Handlebars.registerHelper 'getUsername', window.getUsername

Handlebars.registerHelper 'categories', ->
  for cat in window.categories
    unless cat.url
      cat.url = cat.name.toLowerCase()
  return window.categories

Handlebars.registerHelper 'formatDate', (date) ->
  d = moment(new Date(date))
  return d.format "DD.MM.YYYY, hh:mm"

