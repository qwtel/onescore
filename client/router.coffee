class Router extends Backbone.Router
  constructor: (args) ->
    super args
    Session.set 'scope', 'all'
    Session.set 'sort', 'hot'
    Session.set 'tab-user', 'unlocks'
    Session.set 'tab-achievement', 'unlocks'
    Session.set 'tab-accomplishment', 'people'

  routes:
    '': 'home'
    'home': 'home'
    'explore': 'explore'
    'notification': 'notification'
    'user/:id/:tab': 'user'
    'user/:id': 'user'
    'ladder': 'ladder'
    ':type/:id/:tab': 'single'
    ':type/:id': 'single'
    ':crap': 'home'
    #'achievement/new': 'newAchievement'
    #'achievement/:id/new': 'newAchievement'
    #'user/:id/questlog': 'questlog'

  home: ->
    @hardReset()
    Session.set 'page', 'home'

  explore: ->
    @hardReset()
    Session.set 'page', 'explore'

  ladder: ->
    @hardReset()
    Session.set 'page', 'ladder'

  notification: ->
    @hardReset()
    Session.set 'page', 'notification'

  user: (id, tab) ->
    @hardReset()
    Session.set 'page', 'user'
    Session.set 'id', id
    Session.set 'tab-user', if tab? then tab else 'unlocks'

  questlog: (user) ->
    @profile user
    Session.set 'page', 'questlog'

  newAchievement: (id) ->
    @softReset()
    Session.set 'id', id
    Session.set 'page', 'newAchievement'

  single: (type, id, tab) ->
    @softReset()
    Session.set 'page', type
    Session.set 'id', id
    Session.set "tab-#{type}", if tab? then tab else 'comments'

  softReset: ->
    $(document).scrollTop 0
    Session.set 'limit', 1
    Session.set 'target', null
    Session.set 'type', null
    Session.set 'temp', null
    Session.set 'reply', null

  hardReset: ->
    @softReset()
    Session.set 'id', null

    # Awesome! Thanks to 
    # http://stackoverflow.com/questions/10758112/loop-through-object-get-value-using-regex-key-matches-javascript 
    # Also I'm drunk, lol
    # YOLO
    for key in _.keys Session.keys
      if /target-*/.test(key)
        delete Session.keys[key]

    for key in _.keys Session.keys
      if /limit-*/.test(key)
        delete Session.keys[key]

    for key in _.keys Session.keys
      if /accomplished-*/.test(key)
        delete Session.keys[key]
