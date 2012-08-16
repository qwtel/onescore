_.extend Template.miniQuestLog, Template.favourites,
  achievement: ->
    sel = {}
    sel._id = @entity

    if Session.get('category')?
      sel.category = Session.get 'category'

    acc = Accomplishments.findOne
      user: Meteor.user()._id
      entity: @entity
    if acc
      return false

    return Achievements.findOne sel
