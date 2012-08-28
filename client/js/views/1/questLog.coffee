_.extend Template.questLog, Template.favourites,
  achievement: ->
    #Achievements.findOne @entity
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
