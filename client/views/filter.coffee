Template.filter.events
  'click .sort a': (e) ->
    $t = $(e.currentTarget)
    Session.set 'sort', $t.data 'value'

  'click .scope a': (e) ->
    $t = $(e.currentTarget)
    Session.set 'scope', $t.data 'value'

#Template.filter.helpers

getSelect = ->
  sel = {}
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

getSort = ->
  sort = Session.get 'sort'

  switch sort
    when 'hot' then data = hot: -1
    when 'cool' then data = hot: 1

    when 'new' then data = date: -1
    when 'old' then data = date: 1

    when 'best' then data = best: -1
    when 'worst' then data = best: 1

  return data

