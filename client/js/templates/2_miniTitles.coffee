_.extend Template.miniTitles,
  titles: ->
    titles = Titles.find
      entity: @_id
      user: Meteor.user()._id
    ,
      sort: score: -1
      limit: 5

    #if titles.count() is 0 then return false else titles
