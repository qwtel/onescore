_.extend Template.miniQuestLog, Template.questLog,
  favourites: ->
    sort = Template.filter.sort()

    if (user = Meteor.user())
      Favourites.find
        user: user._id
        active: true
        $where: ->
          not Accomplishments.findOne
            user: user._id
            entity: @entity
      ,
        sort: sort

