_.extend Template.header,
  events:
    'click .category .nav-item': (e) ->
      $t = $(e.target).closest '.category'
      category = $t.data 'category'
      Session.set 'category', category

  items: ->
    for item in window.items
      unless item.url
        item.url = item.name.toLowerCase()
    return window.items
