Template.sort.events
  'click a': (e) ->
    $t = $(e.currentTarget)
    Session.set 'sort', $t.data 'value'

Template.scope.events
  'click a': (e) ->
    $t = $(e.currentTarget)
    Session.set 'scope', $t.data 'value'

Template.scope.getSelect = ->
  sel = {}
  switch Session.get 'scope'
    when 'me'
      sel.user = Meteor.userId()
    when 'friends'
      # TODO: friends
      sel.user = $in: [Meteor.user()._id]

  return sel

Template.sort.getSort = ->
  sort = Session.get 'sort'

  switch sort
    when 'hot' then data = hot: -1
    when 'cool' then data = hot: 1

    when 'new' then data = date: -1
    when 'old' then data = date: 1

    when 'best' then data = best: -1, date: -1
    when 'worst' then data = best: 1, date: -1

  return data
