_.extend Template.titles,
  titles: ->
    titles = Titles.find
      entity: @_id
      user: Meteor.user()._id
    ,
      sort:
        score: -1

    if titles.count() is 0 then return false

    return titles

