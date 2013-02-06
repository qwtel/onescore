_.extend Template.miniQuestLog, Template.questLog,
  achievements: ->
    username = Session.get 'username'
    if username
      user =  Meteor.users.findOne
        username: username

      if user
        quests = Favourites.find
          user: user._id
          active: true
          $where: ->
            not Accomplishments.findOne
              user: user._id
              entity: @entity
          ,
            fields: entity: 1

        quests = quests.fetch()
        quests = _.pluck quests, 'entity'

        if _.size(quests) > 0
          sort = Template.filter.sort()
          sel = Template.filter.select()

          _.extend sel,
            _id: $in: quests

          Achievements.find sel,
            sort: sort
            limit: 5

  #favourites: ->
  #  sort = Template.filter.sort()
  #
  #  if (user = Meteor.user())
  #    Favourites.find
  #      user: user._id
  #      active: true
  #      $where: ->
  #        not Accomplishments.findOne
  #          user: user._id
  #          entity: @entity
  #    ,
  #      sort: sort
  #      limit: 5

