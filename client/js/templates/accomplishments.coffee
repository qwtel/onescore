_.extend Template.accomplishments,
  accomplishments: ->
    return Accomplishments.find
      user: Meteor.user()._id
    ,
      sort:
        date: -1
        _id: -1
