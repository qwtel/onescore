class AppRouter extends Backbone.Router
  routes:
    '': 'default'
    'home': 'home'
    'explore': 'explore'
    'ladder': 'ladder'
    'achievements/:id': 'achievements'
    'achievements/:id/:tab': 'achievements'
    'achievements/:id/:tab/:type': 'achievements'
    'accomplishments/:id': 'accomplishments'
    'accomplishments/:id/:tab': 'accomplishments'
    #'comments/:id': 'comments'
    ':user': 'user'
    ':user/:menu': 'user'

  default: ->
    @navigate 'home', true

  home: ->
    @hardReset()
    Session.set 'page', 'home'
    Session.set 'sort', 'hot'
    Session.set 'limit', 'all'

  explore: ->
    @hardReset()
    Session.set 'page', 'explore'
    Session.set 'sort', 'best'
    Session.set 'limit', 'all'

  ladder: ->
    @hardReset()
    Session.set 'page', 'ladder'
    Session.set 'sort', 'best'
    Session.set 'limit', 'all'

  user: (user, menu) ->
    @hardReset()
    Session.set 'page', 'profile'
    Session.set 'sort', 'new'
    Session.set 'limit', 'me'
    Session.set 'username', user

    unless menu then menu = 'activity'
    Session.set 'menu', menu

  achievements: (id, tab, type) ->
    @softReset()
    Session.set 'page', 'achievements'
    Session.set 'limit', 'all'
    Session.set 'single', id

    unless tab then tab = 'info'
    Session.set 'tab', tab

    if type
      Session.set 'story', type
    else
      Session.set 'story', null

  accomplishments: (id, tab) ->
    @softReset()
    Session.set 'page', 'accomplishments'
    Session.set 'limit', 'all'
    Session.set 'single', id

    unless tab then tab = 'info'
    Session.set 'tab', tab

  comments: (id) ->
    @softReset()
    Session.set 'parent', id
    c = Comments.findOne id
    Session.set 'level', c.level


  softReset: ->
    Session.set 'expand', null
    Session.set 'story', null
    Session.set 'parent', null
    Session.set 'level', 0

    #$('.modal').modal 'hide'
    #Session.set 'add-comment', null
    #Session.set 'edit-comment', null
    #Session.set 'topic', 'dashboard'
    #Session.set 'thread', null
    #Session.set 'activity', null
    #Session.set 'addingTag', null

  hardReset: ->
    @softReset()
    $(document).scrollTop 0
    Session.set 'single', null
    Session.set 'tab', null
    Session.set 'unexpand', null

    #Session.set 'comment-filter', null
    #Session.set 'activity-filter-1', null
    #Session.set 'activity-filter-2', null
    #Session.set 'tagFilter', null

  #activityShow: (id) ->
  #  Session.set 'page', 'activities'
  #  Session.set 'activity', id
  #  Session.set 'topic', id
  #  Meteor.flush()
  #  window.positionActivityModal $('.accomplish-modal'), id
  #
  #activityNew: ->
  #  Session.set 'page', 'activities'
  #  Session.set 'activity', null
  #  Meteor.flush()
  #  window.positionActivityModal $('.create-modal')
  #
  #activityEdit: (id) ->
  #  Session.set 'page', 'activities'
  #  Session.set 'activity', id
  #  Meteor.flush()
  #  window.positionActivityModal $('.create-modal'), id

window.Router = new AppRouter
Meteor.startup ->
  Backbone.history.start pushState: true
