Session.set 'limit', 'all'

class AppRouter extends Backbone.Router
  # NOTE: Some 'pseudo-routs' added to deal with 'dead links'
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
    'achievement/:id': 'achievements'
    'achievement/:id/:tab': 'achievements'
    'achievement/:id/:tab/:type': 'achievements'
    'accomplishments/:id': 'accomplishments'
    'accomplishments/:id/:tab': 'accomplishments'
    'accomplishment/:id': 'accomplishments'
    'accomplishment/:id/:tab': 'accomplishments'
    'comments/:id': 'comments'
    'comments/:id/:something': 'comments'
    'comment/:id': 'comments'
    'comment/:id/:something': 'comments'
    'titles/:id': 'home'
    'votes/:id': 'home'
    ':user': 'user'
    ':user/:menu': 'user'

  default: ->
    @navigate 'home', true

  home: ->
    @hardReset()
    Session.set 'page', 'home'
    Session.set 'sort', 'hot'
    Session.set 'type', 'accomplishment'

  explore: ->
    @hardReset()
    Session.set 'page', 'explore'
    Session.set 'sort', 'best'
    Session.set 'type', 'achievement'

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

    # HACK: to enable the tag filter
    if menu is 'questlog'
      Session.set 'type', 'achievement'
    else
      Session.set 'type', 'accomplishment'

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
    Session.set 'sort', 'all'
    Session.set 'single', id

  comments: (id, something) ->
    @softReset()
    Session.set 'page', 'comments'
    Session.set 'sort', 'best'
    Session.set 'single', id

  softReset: ->
    $(document).scrollTop 0
    Session.set 'tagFilter', null
    Session.set 'menu', null
    Session.set 'newAchievement', null
    Session.set 'expand', null
    Session.set 'story', null
    Session.set 'parent', null
    Session.set 'level', 0

  hardReset: ->
    @softReset()
    Session.set 'single', null
    Session.set 'tab', null
    Session.set 'unexpand', null
    Session.set 'skip', 0

window.Router = new AppRouter
Meteor.startup ->
  Backbone.history.start pushState: true
