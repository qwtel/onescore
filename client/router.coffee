class Router extends Backbone.Router
  routes:
    '': 'home'
    'home': 'home'
    'explore': 'explore'
    'notification': 'notification'
    'user/:id': 'user'
    ':type/:id': 'single'
    ':crap': 'home'
    #'ladder': 'ladder'
    #'achievement/new': 'newAchievement'
    #'achievement/:id/new': 'newAchievement'
    #'user/:id/questlog': 'questlog'

  home: ->
    @hardReset()
    Session.set 'page', 'home'
    Session.set 'scope', 'all'
    Session.set 'sort', 'hot'

  explore: ->
    @hardReset()
    Session.set 'page', 'explore'
    Session.set 'scope', 'all'
    Session.set 'sort', 'hot'

  ladder: ->
    @hardReset()
    Session.set 'page', 'ladder'
    Session.set 'sort', 'best'

  notification: ->
    @hardReset()
    Session.set 'page', 'notification'
    Session.set 'sort', 'new'

  user: (id) ->
    @hardReset()
    Session.set 'id', id
    Session.set 'page', 'user'
    Session.set 'scope', 'all'
    Session.set 'sort', 'new'

  questlog: (user) ->
    @profile user
    Session.set 'page', 'questlog'

  newAchievement: (id) ->
    @softReset()
    Session.set 'id', id
    Session.set 'page', 'newAchievement'

  single: (type, id) ->
    @softReset()
    Session.set 'page', type
    Session.set 'id', id
    Session.set 'sort', 'best'

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
