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
    window.softReset()
    Session.set 'page', page

  activityShow: (id) ->
    Session.set 'page', 'activities'
    Session.set 'activity', id
    Session.set 'topic', id
    Meteor.flush()
    window.positionActivityModal $('.accomplish-modal'), id

  activityNew: ->
    Session.set 'page', 'activities'
    Session.set 'activity', null
    Meteor.flush()
    window.positionActivityModal $('.create-modal')

  activityEdit: (id) ->
    Session.set 'page', 'activities'
    Session.set 'activity', id
    Meteor.flush()
    window.positionActivityModal $('.create-modal'), id

window.Router = new AppRouter
Meteor.startup ->
  Backbone.history.start pushState: true
