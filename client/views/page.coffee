Template.page.events
  'click a[href^="/"]': (e) ->
    if e.which is 1 and not (e.ctrlKey or e.metaKey)
      e.preventDefault()
      $t = $(e.target).closest 'a[href^="/"]'
      href = $t.attr 'href'
      if href then Router.navigate href, true

Template.page.helpers
  skill: -> Skills.findOne 
    _id: Session.get('page')
    nav: true

  user: ->
    id = Session.get 'id'
    Meteor.users.findOne id

  entity: ->
    id = Session.get 'id'
    type = Session.get 'page'
    Collections[type].findOne id

  targetAchievement: ->
    temp = Session.get 'temp'
    if temp?
      Achievements.findOne temp

  targetUser: ->
    temp = Session.get 'temp'
    if temp?
      Meteor.users.findOne temp

  targetAccomplishment: ->
    temp = Session.get 'temp'
    if temp?
      Accomplishments.findOne temp

