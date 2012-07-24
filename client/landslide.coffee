Meteor.subscribe 'ushers', ->
  if cookie.get 'user'
    userId = cookie.get('user')
    Session.set 'user', userId
  else
    userName = Math.floor(1000000 + (Math.random() * ((9999999 - 1000000) + 1)))
    userId = Ushers.insert name: userName
    Session.set 'user', userId
    cookie.set 'user', userId

Session.set 'activitiesLoaded', false
Meteor.subscribe 'activities', ->
  Session.set 'activitiesLoaded', true

Meteor.subscribe 'drafts', Session.get 'user'

Session.set 'topic', 'dashboard'
Meteor.autosubscribe ->
  topic = Session.get 'topic'
  if topic
    Session.set 'commentsLoaded', false
    Meteor.subscribe 'comments', topic, ->
      Session.set 'commentsLoaded', true

###
Meteor.subscribe 'slideshows', ->
  unless Session.get 'slideshow_id'
    slideshow = Slideshows.findOne {},
      sort:
        name: 1

Meteor.autosubscribe ->
  slideshow_id = Session.get 'slideshow_id'
  if slideshow_id
    Meteor.subscribe 'slides', slideshow_id

    slide_id = Session.get 'slide_id'
    if slide_id
      Meteor.subscribe 'comments', slide_id
###


makeOkCancelHandler = (options) ->
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

getThreadId = (comment) ->
  while comment.parent isnt null
    comment = Comments.findOne comment.parent
  return comment._id

focusById = (id) ->
  #$t = $('#'+id)
  #t = $t.val()
  #$t.focus().val('').val(t)
  $('#'+id).focus().select()

findTags = (text) ->
  pattern = /// [^&]\B(#(\w\w+)) ///g
  text = _.escape text

  tags = []
  while match = pattern.exec(text)
    tags.push match[2]

  return tags

wrapTags = (text) ->
  pattern = /// [^&]\B(#(\w\w+)) ///g
  text = _.escape text
  return text.replace pattern, ' <a class="tag" data-tag="$2">$1</a>'

$.fn.clear = ->
  $(this).val ''

positionActivityModal = ($modal, id) ->
  if id?
    p = $('#activity-'+id).offset()

  if not id? or not p?
    p = {}
    p.top = 50

  $modal.modal(keyboard: false, show: true).offset(top: p.top)
    .on 'hide', ->
      $('body').height('auto')
      Router.navigate 'activities', true

  $('body').height($('body').height() + $(window).height())
  $(document).scrollTop(p.top - 50)

getUsername = (userId) ->
  user = Ushers.findOne userId
  if user
    return user.name
  return ''

softReset = ->
  $('.modal').modal 'hide'
  Session.set 'add-comment', null
  Session.set 'edit-comment', null
  Session.set 'topic', 'dashboard'
  Session.set 'thread', null
  Session.set 'activity', null
  Session.set 'addingTag', null

hardReset = ->
  softReset()
  $(document).scrollTop 0
  Session.set 'comment-filter', null
  Session.set 'activity-filter-1', null
  Session.set 'activity-filter-2', null
  Session.set 'tagFilter', null

Handlebars.registerHelper 'isActive', (name, value) ->
  return if Session.equals(name, value) then 'active' else ''

Handlebars.registerHelper 'belongsTo', (user) ->
  return Session.equals 'user', user

Handlebars.registerHelper 'isMe', (user) ->
  return if Session.equals('user', user) then 'my' else ''

Handlebars.registerHelper 'isLva', (user) ->
  return if user <= 2000000 then 'lva' else ''

Handlebars.registerHelper 'userIn', (field) ->
  if field?
    return Session.get('user') in field
  return false

Handlebars.registerHelper 'activity', ->
  activityId = Session.get 'activity'
  activity = Activities.findOne activityId
  return activity or {}

Handlebars.registerHelper 'wrapTags', wrapTags

Handlebars.registerHelper 'getUsername', getUsername

_.extend Template.content,
  page: (page) ->
    return Session.equals 'page', page

_.extend Template.header,
  events:
    'click .nav-item': (e) ->
      Router.navigate $(e.target).data('href'), true

  items: ->
    items = [
        name: 'Explore'
      ,
        name: 'Compete'
    ]

    for item in items
      unless item.url
        item.url = item.name.toLowerCase()
      item.active = if Session.equals('page', item.url) then 'active' else ''

    return items

_.extend Template.dashboard,
  events:
    'click .add-comment': (e) ->
      Session.set 'add-comment', 0
      Session.set 'edit-comment', null

    'click .btn-filter': (e) ->
      filter = $(e.target).data 'filter'
      if filter
        if Session.get('comment-filter') is filter
          Session.set 'comment-filter', null
        else
          Session.set 'comment-filter', filter

    'keyup .comment-text,  keydown .comment-text':
      makeOkCancelHandler
        ok: (text, e) ->
          Comments.insert
            text: text
            date: new Date
            topic: Session.get 'topic'
            parent: null
            mention: null
            user: Session.get 'user'
          Session.set 'add-comment', null
          Session.set 'edit-comment', null
          e.target.value = ""

  addComment: ->
    return Session.equals 'add-comment', 0

_.extend Template.comments,
  events:
    'keyup .comment-text, keydown .comment-text, 
     keyup .edit-text, keydown .edit-text':
      makeOkCancelHandler
        ok: (text, e) ->
          if Session.get('add-comment') isnt null
            Comments.insert
              text: text
              date: new Date
              topic: Session.get 'topic'
              parent: Session.get 'thread'
              mention: @user
              user: Session.get 'user'

          else if Session.equals 'edit-comment', @_id
            Comments.update @_id,
              $set:
                text: text

          Session.set 'add-comment', null
          Session.set 'edit-comment', null
          e.target.value = ""

  select: (id) ->
    sel =
      topic: Session.get 'topic'
      parent: null
    
    if id
      sel.parent = id

    else
      if Session.equals 'comment-filter', 'my'
        sel.user = Session.get 'user'

      else if Session.equals 'comment-filter', 'lva'
        sel.user = $lt: 2000000

    return sel

  comments: ->
    sel = Template.comments.select()
    return Comments.find sel,
      sort:
        date: -1

  replies: ->
    sel = Template.comments.select(@_id)
    return Comments.find sel,
      sort:
        date: 1

  noContent: ->
    if Session.equals 'commentsLoaded', true
      sel = Template.comments.select()
      return Comments.find(sel).count() is 0
    return false

_.extend Template.achievement,
  events:
    'click .reply': (e) ->
      Session.set 'add-comment', @_id
      Session.set 'edit-comment', null
      Session.set 'thread', getThreadId(this)
      Meteor.flush()
      focusById "reply-#{@_id}"

    'click .like': (e) ->
      Comments.update @_id,
        $push:
          likes: Session.get 'user'

    'click .unlike': (e) ->
      Comments.update @_id,
        $pull:
          likes: Session.get 'user'

    'click .edit': (e) ->
      Session.set 'add-comment', null
      Session.set 'edit-comment', @_id
      Session.set 'thread', getThreadId(this)
      Meteor.flush()
      focusById "reply-#{@_id}"

    'click .remove': (e) ->
      Comments.remove @_id

  addComment: ->
    return Session.equals 'add-comment', @_id

  editComment: ->
    return Session.equals 'edit-comment', @_id
  
  formatDate: (date) ->
    d = moment(new Date(@date))
    return d.format "DD.MM.YYYY, hh:mm"

  likesNum: ->
    return if @likes? then @likes.length else 0
  
  nested: ->
    return if @parent then 'nested' else ''
  
  addLineBreaks: (text) ->
    text = _.escape text
    return text.replace '\n', '<br>'

  mention: ->
    if @mention isnt null
      return "@#{getUsername(@mention)}:"

_.extend Template.activities,
  events:
    'click #create .open': (e) ->
      Router.navigate 'activities/new', true

    'click .btn-filter': (e) ->
      Session.set 'tagFilter', null
      filter = $(e.target).data 'filter'
      which = $(e.target).data 'which'
      if Session.get("activity-filter-#{which}") is filter
          Session.set "activity-filter-#{which}", null
      else
        Session.set "activity-filter-#{which}", filter

  activities: ->
    sel = Template.activities.select()

    if Session.get 'tagFilter'
      sel.tags = Session.get 'tagFilter'

    return Activities.find sel,
      sort:
        score: -1
        name: 1

  select: ->
    sel = {}

    if Session.equals 'activity-filter-1', 'my'
      sel.user = Session.get 'user'

    else if Session.equals 'activity-filter-1', 'lva'
      sel.user = $lt: 2000000

    if Session.equals 'activity-filter-2', 'fav'
      sel.likes = Session.get 'user'

    else if Session.equals 'activity-filter-2', 'voted'
      sel.votes = Session.get 'user'

    else if Session.equals 'activity-filter-2', 'saved'
      drafts = Drafts.find(
        user: Session.get 'user'
        handedIn: false
      ).map (draft) ->
        return draft.activity
      sel._id = $in: drafts

    else if Session.equals 'activity-filter-2', 'pending'
      drafts = Drafts.find(
        user: Session.get 'user'
        handedIn: true
      ).map (draft) ->
        return draft.activity
      sel._id = $in: drafts

    else if Session.equals 'activity-filter-2', 'done'
      sel = null

    return sel

  noContent: ->
    if Session.equals 'activitiesLoaded', true
      sel = Template.activities.select()
      return Activities.find(sel).count() is 0
    return false

_.extend Template.tags,
  events:
    'click .add': (e) ->
      if @_id
        Session.set 'addingTag', @_id
      else
        Session.set 'addingTag', 'new'
      Meteor.flush()
      focusById('edittag-'+@_id)

    'click .remove': (e) ->
      id = $(e.target).attr('id')
      if id isnt ''
        if Session.equals 'page', 'activities'
          Activities.update id,
            $pull:
              tags: @tag

    'keyup .edittag-input,  keydown .edittag-input':
      makeOkCancelHandler
        ok: (text, e) ->
          unless @tags
            @tags = []

          unless _.contains @tags, text
            @tags.push text

          Session.set 'addingTag', null
          if Session.equals 'page', 'activities'
            Activities.update @_id,
              $set:
                tags: @tags

  tags: ->
    tagInfos = []

    _.each @tags, (tag) ->
      tagInfo = _.find tagInfos, (x) ->
        return (x.tag is tag)
      if not tagInfo
        tagInfos.push
          tag: tag

    tagInfos = _.sortBy tagInfos, (x) ->
      return x.tag

    return tagInfos

  addingTag: ->
    if @_id
      return Session.equals 'addingTag', @_id
    else
      return Session.equals 'addingTag', 'new'

_.extend Template.tagFilter,
  events:
    'click .tag': (e) ->
      if Session.equals 'tagFilter', @tag
        Session.set 'tagFilter', null
      else
        Session.set 'tagFilter', @tag

  tags: ->

    if Session.equals 'page', 'activities'
      sel = Template.activities.select()
      entities = Activities.find(sel)
    else if Session.equals 'page', 'slides'
      sel = Template.slideshows.select()
      entities = Slideshows.find(sel)

    tagInfos = []

    entities.forEach (activity) ->
      _.each activity.tags, (tag) ->
        tagInfo = _.find tagInfos, (x) ->
          return (x.tag is tag)
        if not tagInfo
          tagInfos.push
            tag: tag
            count: 1
        else
          tagInfo.count++

    tagInfos = _.sortBy tagInfos, (x) ->
      return x.tag

    return tagInfos

_.extend Template.activity,
  events:
    'click .open': (e) ->
      if @_id
        Router.navigate 'activities/show/'+@_id, true

    'click .edit': (e) ->
      if @_id
        Router.navigate 'activities/edit/'+@_id, true

    'click .like': (e) ->
      Activities.update @_id,
        $push:
          likes: Session.get 'user'

    'click .unlike': (e) ->
      Activities.update @_id,
        $pull:
          likes: Session.get 'user'

    'click .up': (e) ->
      if not @votes or not (Session.get('user') in @votes)
        Activities.update @_id,
          $inc:
            score: 1
          $push:
            votes: Session.get 'user'

    'click .down': (e) ->
      if not @votes or not (Session.get('user') in @votes)
        Activities.update @_id,
          $inc:
            score: -1
          $push:
            votes: Session.get 'user'

    'click .remove': (e) ->
      Drafts.remove
        activity: @_id
        user: Session.get 'user'
      Activities.remove @_id

    'click .tag': (e) ->
      tag = $(e.target).data 'tag'
      Session.set 'tagFilter', tag

  score: ->
    return if @score > 0 then @score else 0

Session.set 'editUsername', false

_.extend Template.userWidget,
  events:
    'click .edit': (e) ->
      value = Session.get 'editUsername'
      Session.set 'editUsername', !value
      Meteor.flush()
      $('#user-name').focus()

    'keyup #user-name, keydown #user-name':
      makeOkCancelHandler
        ok: (text, e) ->
          text = text.replace /// \s ///g, ''
          Ushers.update @_id,
            name: text
          Session.set 'editUsername', false

  user: ->
    return Ushers.findOne Session.get('user')

  editUsername: ->
    return Session.equals 'editUsername', true

_.extend Template.createActivityModal,
  events:
    'click .create-activity': (e) ->
      name = $('.activity-name').val()
      url = encodeURIComponent((name.toLowerCase()).replace(/// \s ///g, '-'))
      tags = findTags $('.description-short').val()

      _.each @tags, (x) ->
        unless _.contains tags, x
          tags.push x

      data =
        name: name
        short: $('.description-short').val()
        full: $('.description-full').val()
        user: Session.get 'user'
        tags: tags
        url: url

      if Session.get 'activity'
        Activities.update @_id, $set: data
      else
        data.score = 0
        Activities.insert data

      $('.create-modal').modal 'hide'
      $('.activity-name, .description-short, .description-full').clear()

  title: ->
    activityId = Session.get 'activity'
    if activityId
      return @name
    else
      return 'Create New Activity'

_.extend Template.accomplishActivityModal,
  events:
    'click .save-activity': (e) ->
      data =
        user: Session.get 'user'
        activity: Session.get 'activity'
        text: $('.accomplish-text').val()
        handedIn: false

      draft = Drafts.findOne
        user: Session.get 'user'
        activity: Session.get 'activity'

      if draft?
        if data.text isnt ''
          Drafts.update draft._id, $set: data
        else
          Drafts.remove draft._id
      else
        Drafts.insert data

      $('.accomplish-modal').modal 'hide'

    'click .hand-in-activity': (e) ->
      draft = Drafts.findOne
        user: Session.get 'user'
        activity: Session.get 'activity'

      Drafts.update draft,
        $set:
          handedIn: true

      $('.accomplish-modal').modal 'hide'

  draft: ->
    draft = Drafts.findOne
      user: Session.get 'user'
      activity: Session.get 'activity'

    return draft or {}

class AppRouter extends Backbone.Router
  routes:
    '': 'default'
    ':menu': 'menu'
    'activities/new': 'activityNew'
    'activities/show/:id': 'activityShow'
    'activities/edit/:id': 'activityEdit'

  default: ->
    @navigate 'dashboard', true

  menu: (page) ->
    softReset()
    Session.set 'page', page

  activityShow: (id) ->
    Session.set 'page', 'activities'
    Session.set 'activity', id
    Session.set 'topic', id
    Meteor.flush()
    positionActivityModal $('.accomplish-modal'), id

  activityNew: ->
    Session.set 'page', 'activities'
    Session.set 'activity', null
    Meteor.flush()
    positionActivityModal $('.create-modal')

  activityEdit: (id) ->
    Session.set 'page', 'activities'
    Session.set 'activity', id
    Meteor.flush()
    positionActivityModal $('.create-modal'), id

Router = new AppRouter
Meteor.startup ->
  Backbone.history.start pushState: true

_.extend Template.slideshows,
  events:
    'click .btn-filter': (e) ->
      Session.set 'tagFilter', null
      filter = $(e.target).data 'filter'
      which = $(e.target).data 'which'
      if Session.get("slideshow-filter-#{which}") is filter
          Session.set "slideshow-filter-#{which}", null
      else
        Session.set "slideshow-filter-#{which}", filter

    'click .open': (e) ->
      console.log 'navigate'
      Router.navigate 'slides/'+@_id, true

  select: ->
    sel = {}

    if Session.equals 'slideshow-filter-1', 'my'
      sel.user = Session.get 'user'

    else if Session.equals 'slideshow-filter-1', 'lva'
      sel.user = $lt: 2000000

    if Session.equals 'slideshow-filter-2', 'fav'
      sel.likes = Session.get 'user'

    return sel

  slideshows: ->
    return Slideshows.find()

_.extend Template.slides,
  events:
    'click #next': (e) ->

    'click #prev': (e) ->
