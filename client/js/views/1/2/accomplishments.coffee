_.extend Template.accomplishments,
  select: ->
    sel = {}
    if Session.get('tagFilter')?
      sel.tags = Session.get 'tagFilter'
    return sel

  accomplishments: ->
    sort = Template.filter.sort()

    username = Session.get 'username'
    if username
      user =  Meteor.users.findOne
        username: username

      if user
        sel = Template.accomplishments.select()
        _.extend sel,
          user: user._id

        return Accomplishments.find sel,
          sort: sort
