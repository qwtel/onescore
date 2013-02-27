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

  entity: ->
    id = Session.get 'id'
    type = Session.get 'page'
    Collections[type].findOne id

