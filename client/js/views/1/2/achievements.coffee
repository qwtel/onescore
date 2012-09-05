_.extend Template.achievements,
  events:
    'click .btn': (e) ->
      filter = $(e.currentTarget).data 'filter'
      console.log filter
      Session.toggle "btn-#{filter}", true

  achievements: ->
    sort = Template.filter.sort()
    sel = Template.filter.select()

    sel.created = true
    sel.$where = ->
      a = Accomplishments.findOne
        user: Meteor.user()._id
        entity: @_id

      f = Favourites.findOne
        user: Meteor.user()._id
        entity: @_id
        active: true

      if not Session.get('btn-completed') and not Session.get('btn-accepted')
        return not a and not f
      else if not Session.get('btn-completed')
        return not a
      else if not Session.get('btn-accepted')
        return not f
      else
        return true

    achievements = Achievements.find sel, sort: sort

    if achievements.count() is 0
      return false

    return achievements

  #select: ->
  #  sel = {}
  #  sel.created = true
  #
  #  if Session.get('category')?
  #    sel.category = Session.get 'category'
  #
  #  if Session.get('tagFilter')?
  #    Session.get '_tagFilter'
  #    sel.tags = $all: Session.get 'tagFilter'
  #
  #  switch Session.get('limit')
  #    when 'me'
  #      sel.user = Meteor.user()._id
  #    when 'friends'
  #      sel.user = $in: [Meteor.user()._id]
  #
  #  return sel

