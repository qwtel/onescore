_.extend Template.header,
  events: ->
    'click .category .nav-item': (e) ->
      $t = $(e.target).closest '.category'
      category = $t.data 'category'
      Session.set 'category', category

  rendered: ->
    # XXX: Does this create a memory leak?
    $('.popover').remove()

    $('.spell').popover
      placement: 'bottom'
      trigger: 'hover'

  pic: ->
    user = Meteor.user()
    if user
      if user.services
        fbid = _.escape user.services.facebook.id
        return "<img src='https://graph.facebook.com/#{fbid}/picture'/>"

  items: ->
    [
        name: 'Home'
        url: 'home'
        icon: 'home'
        description: 'View success stories of other players'
        active: window.isActive 'page', 'home'
      ,
        name: 'Notifications'
        icon: 'envelope'
        url: 'notifications'
        description: 'See how other users interact with your content'
        active: window.isActive 'page', 'notifications'
        counter: true
      ,
        name: 'Explore'
        url: 'explore'
        icon: 'globe'
        description: 'Allows you to find achievements'
        active: window.isActive 'page', 'explore'
      ,
        name: 'Ladder'
        url: 'ladder'
        icon: 'th-list'
        description: 'Compete with other players based on your score'
        active: window.isActive 'page', 'ladder'
      ,
        name: 'Profile'
        url: Meteor.user().username
        icon: 'user'
        description: 'Check out your recent activity'
        active: if Session.equals('page', 'profile') and
          not Session.equals('menu', 'questlog') then 'active' else ''
      ,
        name: 'Quest Log'
        icon: 'glass'
        url: Meteor.user().username+'/questlog'
        description: 'Keept track of achievements you want to complete'
        active: if Session.equals('page', 'profile') and
          Session.equals('menu', 'questlog') then 'active' else ''
      ,
        name: 'New achievement'
        icon: 'certificate'
        url: 'achievements/new'
        description: 'Create a new achievement'
        cooldown: '30 seconds cooldown'
        active: window.isActive 'page', 'newAchievement'
      ,
        name: 'Accept (passive)'
        icon: 'star'
        url: '#'
        passive: true
        description: 'Allows you to add achievements to your quest log'
        cooldown: '1 second cooldown'
      ,
        name: 'Vote (passive)'
        icon: 'arrow-up'
        url: '#'
        passive: true
        description: 'Allows you to vote for content'
        cooldown: '1 second cooldown'
      ,
        name: 'Comment (passive)'
        icon: 'comment'
        url: '#'
        passive: true
        description: 'Allows you to comment on content'
        cooldown: '5 seconds cooldown'
      ,
        name: 'Accomplish (passive)'
        icon: 'certificate'
        url: '#'
        passive: true
        description: 'Gives you the ability to accomplish achievements'
        cooldown: '30 seconds cooldown'
      ,
        name: 'Tag (passive)'
        icon: 'tag'
        url: '#'
        passive: true
        description: 'Allows you to tag content'
        cooldown: '1 second cooldown'
    ]

  isPassive: ->
    return if @passive then 'passive' else ''

  numNotifications: ->
    if Meteor.user()
      user = Meteor.user()._id
      Notifications.find(
        user: $ne: user
        receivers: user
        seen: $ne: user
      ).count()
