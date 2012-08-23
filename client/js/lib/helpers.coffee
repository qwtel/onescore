window.items = [
    name: 'Home'
  ,
    name: 'Explore'
  ,
    name: 'Ladder'
]

# Categories should become tags (with capital letters) and the top 10 tags
# become 'categories'
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

window.focusById = (id) ->
  #$t = $('#'+id)
  #t = $t.val()
  #$t.focus().val('').val(t)
  $("##{id}").focus()#.select()

window.findTags = (text) ->
  pattern = /// [^&]\B(#(\w\w+)) ///g
  text = ' '+text
  text = _.escape text

  tags = []
  while match = pattern.exec(text)
    tag = match[2]
    tag = tag.replace(///\s///g,'')
    tags.push tag

  return tags

window.wrapTags = (text) ->
  if text
    pattern = /// [^&]\B(#(\w\w+)) ///g
    text = ' '+text
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

Session.embed = (name, key, value) ->
  field = Session.get name
  unless field
    field = {}

  if field[key] is value
    field[key] = null
  else
    field[key] = value

  Session.set name, field

Session.push = (name, value) ->
  field = Session.get name
  unless field
    field = []

  if _.contains field, value
    field = _.without field, value
  else
    field.push value

  if _.size(field) > 0
    Session.set name, field
  else
    Session.set name, null
  
  Session.toggle '_'+name, true

Session.union = (name, values) ->
  field = Session.get name
  unless field
    field = []

  field = _.union field, values

  Session.set name, field
  Session.toggle '_'+name, true

Handlebars.registerHelper 'session', (name) ->
  return Session.get name

Handlebars.registerHelper 'show', (name) ->
  return Session.equals name, true

Handlebars.registerHelper 'equals', (name, value) ->
  return Session.equals name, value

Handlebars.registerHelper 'isActive', (name, value) ->
  field = Session.get name

  if field instanceof Array or field instanceof Object
    Session.get '_'+name
    state =  _.contains field, value
  else
    state = Session.equals name, value

  return if state is true then 'active' else ''

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

Handlebars.registerHelper 'timeago', (date) ->
  d = moment(new Date(date))
  d.fromNow()

Handlebars.registerHelper 'addLineBreaks', (text) ->
  text = _.escape text
  return text.replace '\n', '<br>'
