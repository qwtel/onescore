Template.achievements.events

Template.achievements.helpers
  achievements: ->
    sel = Template.filter.getSelect()
    sel.parent = null

    sort = Template.filter.getSort()
    Achievements.find sel,
      sort: sort
      limit: 5 * Session.get 'limit'
