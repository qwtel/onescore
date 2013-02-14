Template.achievements.events()

Template.achievements.helpers
  achievements: ->
    sel = getSelect()
    sel.parent = null
    Achievements.find sel,
      sort: getSort()
      limit: 15

