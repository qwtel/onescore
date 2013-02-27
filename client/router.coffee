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
    'accomplishment/:id': 'accomplishment'
    'user/:id': 'user'
    #'user/:id/questlog': 'questlog'
    ':crap': 'home'

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
      data =
        score: 0
        hot: 0
        best: 0
        value: 0
        comments: 0
        upVotes: 0
        votes: 0
        #===
        type: 'achievement'
        title: ''
        parent: if id then id else null
        description: ''
        favourites: 0
        accomplishments: 0
      Scratchpad.insert data

    Session.set 'id', id
    Session.set 'page', 'newAchievement'

  achievement: (id) ->
    @softReset()
    Session.set 'page', 'achievement'
    Session.set 'id', id
    Session.set 'sort', 'best'

  accomplishment: (id) ->
    @softReset()
    Session.set 'page', 'accomplishment'
    Session.set 'id', id
    Session.set 'sort', 'best'

  softReset: ->
    $(document).scrollTop 0
    Session.set 'limit', 1
    Session.set 'target', null
    Session.set 'type', null

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
