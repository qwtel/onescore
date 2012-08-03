_.extend Template.accomplishment,
  achievement: ->
    sel = {}
    sel._id = @entity

    if Session.get('category')?
      sel.category = Session.get 'category'

    Achievements.findOne sel

  user: ->
    return Meteor.users.findOne @user
