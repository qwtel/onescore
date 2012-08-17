_.extend Template.miniQuestLog, Template.questLog,
  favourites: ->
    sort = Template.filter.sort()

    user = Meteor.user()
    if user
      Favourites.find
        user: user._id
        active: true
      ,
        sort: sort

