_.extend Template.ladder,
  select: () ->
    sel = {}
    return sel

  users: ->
    sel = Template.ladder.select()
    return Meteor.users.find sel,
      sort:
        score: -1
        _id: -1
