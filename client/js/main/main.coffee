class AppRouter extends Backbone.Router
  routes:
    '': 'default'
    ':menu': 'menu'
    ':user': 'user'
    'achievements/:id': 'achievements'
    'achievements/:id/:tab': 'achievements'
    'accomplishments/:id': 'accomplishments'
    'accomplishments/:id/:tab': 'accomplishments'
    'profile/:menu': 'profile'
    'comments/:id': 'comments'

  default: ->
    @navigate 'dashboard', true

  menu: (page) ->
    @hardReset()
    switch page
      when 'dashboard'
        Session.set 'sort', 'hot'
        Session.set 'page', page
        Session.set 'limit', 'all'
      when 'achievements'
        Session.set 'sort', 'best'
        Session.set 'page', page
        Session.set 'limit', 'all'
      when 'ladder'
        Session.set 'sort', 'best'
        Session.set 'page', page
        Session.set 'limit', 'all'
      when 'profile'
        Session.set 'sort', 'new'
        Session.set 'menu', 'activity'
        Session.set 'page', page
        Session.set 'limit', 'me'
      else
        Session.set 'sort', 'new'
        Session.set 'menu', 'activity'
        Session.set 'page', 'profile'
        Session.set 'limit', 'me'

  comments: (id) ->
    @softReset()
    Session.set 'parent', id
    c = Comments.findOne id
    Session.set 'level', c.level

  achievements: (id, tab) ->
    @softReset()
    Session.set 'page', 'achievements'
    Session.set 'limit', 'all'
    Session.set 'single', id

    unless tab then tab = 'info'
    Session.set 'tab', tab

  accomplishments: (id, tab) ->
    @softReset()
    Session.set 'page', 'accomplishments'
    Session.set 'limit', 'all'
    Session.set 'single', id

    unless tab then tab = 'info'
    Session.set 'tab', tab

  user: (user) ->
    console.log user
    @profile()

  profile: (menu) ->
    @softReset()
    Session.set 'page', 'profile'

    unless menu then menu = 'activity'
    Session.set 'menu', menu
    return false

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
