_.extend Template.titles,
  titles: ->
    test = Titles.find
      entity: @_id
      user: Meteor.user()._id

    titles = Titles.find
      entity: @_id
      user: Meteor.user()._id
    ,
      sort: score: -1
      limit: 5*(Session.get('skip')+1)

    if test.count() is 0 then false else titles

  user: ->
    return Meteor.users.findOne @user
