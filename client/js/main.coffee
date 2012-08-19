Session.set 'limit', 'all'

class AppRouter extends Backbone.Router
  routes:
    '': 'default'
    'home': 'home'
    'explore': 'explore'
    'ladder': 'ladder'
    'notifications': 'notifications'
    'achievements/new': 'newAchievement'
    'achievements/:id': 'achievements'
    'achievements/:id/:tab': 'achievements'
    'achievements/:id/:tab/:type': 'achievements'
    'accomplishments/:id': 'accomplishments'
    'accomplishments/:id/:tab': 'accomplishments'
    'comments/:id': 'comments'
    'comments/:id/:something': 'comments'
    ':user': 'user'
    ':user/:menu': 'user'

  default: ->
    @navigate 'home', true

  home: ->
    @hardReset()
    Session.set 'page', 'home'
    Session.set 'sort', 'hot'

  explore: ->
    @hardReset()
    Session.set 'page', 'explore'
    Session.set 'sort', 'best'

  ladder: ->
    @hardReset()
    Session.set 'page', 'ladder'
    Session.set 'sort', 'best'

  notifications: ->
    @hardReset()
    Session.set 'page', 'notifications'
    Session.set 'sort', 'new'

  user: (user, menu) ->
    @hardReset()
    Session.set 'page', 'profile'
    Session.set 'sort', 'new'
    Session.set 'username', user

    unless menu then menu = 'activity'
    Session.set 'menu', menu

  newAchievement: ->
    @softReset()
    Session.set 'page', 'achievements'
    Session.set 'tab', 'edit'
    id = Meteor.call 'newAchievement', (error, result) ->
      unless error
        Session.set 'single', result
        Session.set 'newAchievement', result

  achievements: (id, tab, type) ->
    @softReset()
    Session.set 'page', 'achievements'
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
    Session.set 'single', id

  comments: (id, something) ->
    @softReset()
    Session.set 'page', 'comments'
    Session.set 'sort', 'best'
    Session.set 'single', id

  softReset: ->
    $(document).scrollTop 0
    Session.set 'expand', null
    Session.set 'story', null
    Session.set 'parent', null
    Session.set 'level', 0

  hardReset: ->
    @softReset()
    Session.set 'single', null
    Session.set 'tab', null
    Session.set 'unexpand', null

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
