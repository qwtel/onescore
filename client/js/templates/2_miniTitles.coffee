_.extend Template.miniTitles,
  titles: ->
    test = Titles.find
      entity: @_id
      user: Meteor.user()._id

    titles = Titles.find
      entity: @_id
      user: Meteor.user()._id
    ,
      sort: score: -1
      limit: 5

    if test.count() is 0 then false else titles
