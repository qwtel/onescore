_.extend Template.achievements,
  select: ->
    sel = {}
    sel.created = true

    if Session.get('category')?
      sel.category = Session.get 'category'

    if Session.get('tagFilter')?
      Session.get '_tagFilter'
      sel.tags = $all: Session.get 'tagFilter'

    switch Session.get('limit')
      when 'me'
        sel.user = Meteor.user()._id
      when 'friends'
        sel.user = $in: [Meteor.user()._id]

    return sel

  achievements: ->
    sel = Template.achievements.select()
    sort = Template.filter.sort()

    a = Achievements.find sel,
      sort: sort
    return a
