_.extend Template.filter,
  events:
    'change .sort': (e) ->
      $t = $(e.currentTarget)
      Session.set 'sort', $t.find(':selected').val()

    'click .tab': (e) ->
      $t = $(e.currentTarget)
      Session.set 'limit', $t.data 'tab'

    'keyup .search-query,  keydown .search-query':
      makeOkCancelHandler
        ok: (text, e) ->
          $(e.currentTarget).blur()
          tags = window.findTags text
          if tags and _.size(tags) > 0
            Session.set 'tagFilter', tags
          else
            Session.set 'tagFilter', null
        cancel: (e) ->
          $(e.currentTarget).blur()
          Session.set 'tagFilter', null

  query: ->
    Session.get '_tagFilter'
    tags = Session.get 'tagFilter'
    if tags and _.size(tags) > 0
      tags = tags.join ' #'
      return '#'+tags

  select: ->
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

  sort: ->
    sort = Session.get 'sort'

    switch sort
      when 'hot' then data = hot: -1
      when 'cool' then data = hot: 1

      when 'new' then data = date: -1
      when 'old' then data = date: 1

      when 'best' then data = best: -1
      when 'worst' then data = best: 1

    return data

