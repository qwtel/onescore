class AppRouter extends Backbone.Router
  routes:
    '': 'default'
    ':menu': 'menu'
    'achievements/:id': 'achievements'
    'achievements/:id/:tab': 'achievements'
    'accomplishments/:id': 'accomplishments'
    'accomplishments/:id/:tab': 'accomplishments'
    #'activities/new': 'activityNew'
    #'activities/show/:id': 'activityShow'
    #'activities/edit/:id': 'activityEdit'

  default: ->
    @navigate 'dashboard', true

  menu: (page) ->
    @hardReset()
    Session.set 'page', page

  achievements: (id, tab) ->
    @softReset()
    Session.set 'page', 'achievements'
    Session.set 'single', id

    unless tab then tab = 'info'
    Session.set 'tab', tab

  accomplishments: (id, tab) ->
    @softReset()
    Session.set 'page', 'accomplishments'
    Session.set 'single', id

    unless tab then tab = 'info'
    Session.set 'tab', tab

  softReset: ->
    Session.set 'expand', null

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
