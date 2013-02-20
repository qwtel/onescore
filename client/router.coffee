class Router extends Backbone.Router
  routes:
    '': 'home'
    'home': 'home'
    'explore': 'explore'
    #'ladder': 'ladder'
    #'notifications': 'notifications'
    'achievement/new': 'newAchievement'
    'achievement/:id/new': 'newAchievement'
    'achievement/:id': 'achievement'
    'user/:id': 'user'
    #'user/:id/questlog': 'questlog'
    ':crap': 'home'

  home: ->
    @hardReset()
    Session.set 'page', 'home'
    Session.set 'sort', 'hot'

  explore: ->
    @hardReset()
    Session.set 'page', 'explore'
    Session.set 'scope', 'all'
    Session.set 'sort', 'best'

  ladder: ->
    @hardReset()
    Session.set 'page', 'ladder'
    Session.set 'sort', 'best'

  notifications: ->
    @hardReset()
    Session.set 'page', 'notifications'
    Session.set 'sort', 'new'

  user: (id) ->
    @hardReset()
    Session.set 'id', id
    Session.set 'page', 'user'
    Session.set 'scope', 'me'
    Session.set 'sort', 'new'

  questlog: (user) ->
    @profile user
    Session.set 'page', 'questlog'

  newAchievement: (id) ->
    @softReset()

    newAchievement = Scratchpad.findOne type: 'achievement'

    if not newAchievement
      data = _.extend basic(),
        type: 'achievement'
        title: ''
        parent: if id then id else null
        description: ''
        favourites: 0
        accomplishments: 0
      Scratchpad.insert data

    Session.set 'id', id
    Session.set 'page', 'newAchievement'

  achievement: (id, tab, tabtab) ->
    @softReset()
    Session.set 'page', 'achievement'
    Session.set 'id', id

  softReset: ->
    $(document).scrollTop 0
    Session.set 'target', null
    Session.set 'type', null
    Session.set 'limit', 1

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
