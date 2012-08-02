_.extend Template.achievements,
  events:
    'click .new': (e) ->
      Session.toggle 'expand', @_id
      Session.set 'expandTab', 'edit'

  select: () ->
    sel = {}
    sel.created = true
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

