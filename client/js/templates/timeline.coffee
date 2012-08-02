_.extend Template.timeline,
  accomplishments: ->
    return Accomplishments.find
      user: Meteor.user()._id

  achievement: ->
    return Achievements.findOne @entity


