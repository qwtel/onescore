Session.set 'limit', 'all'

# XXX
formData = null

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

    Session.set 'btn-completed', true
    Session.set 'btn-accepted', true

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

    a = Scratchpad.findOne
      type: 'achievement'

    if a
      id = a._id
    else
      data =
        collection: 'scratchpad'
        user: Meteor.user()._id
        date: new Date().getTime()
        type: 'achievement'
        score: 0
        hot: 0
        best: 0
        value: 0
        comments: 0
        upVotes: 0
        votes: 0
        description: ""
        lastModifiedBy: Meteor.user()._id
        category: 'random'
      id = Scratchpad.insert data
    
    Session.set 'page', 'newAchievement'
    Session.set 'single', id

  achievements: (id, tab, tabtab) ->
    @softReset()
    Session.set 'page', 'achievements'
    Session.set 'single', id

    unless tab then tab = 'info'
    Session.set 'tab', tab

    switch tab
      when 'accomplish'
        unless tabtab then tabtab = null
        Session.set 'story', tabtab

        a = Accomplishments.findOne
          user: Meteor.userId()
          entity: id

        if a
          delete a._id
          a.collection = 'scratchpad'
          return Scratchpad.insert a

        a = Scratchpad.findOne
          type: 'accomplishment'
          entity: id
        if a then return

        Scratchpad.insert
          collection: 'scratchpad'
          user: Meteor.user()._id
          date: new Date().getTime()
          type: 'accomplishment'
          score: 0
          hot: 0
          best: 0
          value: 0
          comments: 0
          upVotes: 0
          votes: 0
          lastModifiedBy: Meteor.user()._id
          entityType: 'achievement'
          entity: id
          story: ''
          facebookImageId: null
          tags: null

        # XXX
        formData = new FormData()

      when 'edit' 
        unless tabtab then tabtab = 'basic'
        Session.set 'skip', 0
        Session.set 'tabtab', tabtab

  accomplishments: (id, tab) ->
    @softReset()
    Session.set 'page', 'accomplishments'
    Session.set 'single', id

    unless tab then tab = 'info'
    Session.set 'tab', tab

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

    Scratchpad.remove type: 'accomplishment'

window.Router = new AppRouter
Meteor.startup ->
  Backbone.history.start pushState: true

  Accounts.ui.config
    requestPermissions:
      facebook: [
        "user_about_me"
        "user_location"
      ]

