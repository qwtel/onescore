Template.sort.events
  'change select': (e) ->
    $t = $(e.currentTarget)
    Session.set 'sort', $t.find(':selected').val() 

Template.sort.helpers
  sel: (e) ->
    if Session.equals 'sort', e then 'selected' else ''

Template.scope.events
  'change select': (e) ->
    $t = $(e.currentTarget)
    Session.set 'scope', $t.find(':selected').val() 

Template.scope.helpers
  sel: (e) ->
    if Session.equals 'scope', e then 'selected' else ''

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
