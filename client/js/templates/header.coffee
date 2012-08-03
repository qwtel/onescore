_.extend Template.header,
  events:
    'click .category .nav-item': (e) ->
      $t = $(e.target).parents '.category'
      category = $t.data 'category'
      Session.set 'category', category

    'click .nav-item': (e) ->
      if e.which is 1
        e.preventDefault()
        window.Router.navigate $(e.target).attr('href'), true

  items: ->
    for item in window.items
      unless item.url
        item.url = item.name.toLowerCase()
    return window.items
