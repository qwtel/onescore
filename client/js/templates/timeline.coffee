_.extend Template.timeline,
  accomplishments: ->
    return Accomplishments.find
      user: Meteor.user()._id
    ,
      sort:
        _id: -1

  achievement: ->
    return Achievements.findOne @entity


