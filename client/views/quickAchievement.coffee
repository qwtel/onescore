Template.quickAchievement.helpers
  doneThat: ->
    if Meteor.userId()
      a = Accomplishments.findOne
        entity: @_id
        user: Meteor.userId()
        active: true
      return a
    return false
