_.extend Template.achievements,
  events:
    'click .new': (e) ->
      Session.toggle 'expand', @_id
      Session.set 'tab', 'edit'

  select: () ->
    sel = {}
    sel.created = true

    if Session.get('category')?
      sel.category = Session.get 'category'

    return sel

  achievements: ->
    sel = Template.achievements.select()
    return Achievements.find sel,
      sort:
        score: -1
        _id: -1

  newAchievement: ->
    id = Session.get 'newAchievement'
    return Achievements.findOne id

  noContent: ->
    if Session.equals 'achievementsLoaded', true
      sel = Template.achievements.select()
      return Achievements.find(sel).count() is 0
    return false

