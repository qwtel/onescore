_.extend Template.accomplishments,
  select: ->
    sel = {}
    if Session.get('tagFilter')?
      Session.get '_tagFilter'
      sel.tags = $all: Session.get 'tagFilter'

    switch Session.get('limit')
      when 'me'
        sel.user = Meteor.user()._id
      when 'friends'
        sel.user = $in: [Meteor.user()._id]

    return sel

  accomplishments: ->
    username = Session.get 'username'
    if username
      user = Meteor.users.findOne
        username: username

      if user
        sel = Template.accomplishments.select()
        _.extend sel,
          user: user._id

        sort = Template.filter.sort()
        return Accomplishments.find sel,
          sort: sort
          limit: 15*(Session.get('skip')+1)

