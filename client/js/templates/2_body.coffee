_.extend Template.body,
  events:
    'click a[href^="/"]': (e) ->
      if e.which is 1 and not (e.ctrlKey or e.metaKey)
        e.preventDefault()
        $t = $(e.target).closest 'a[href^="/"]'
        href = $t.attr 'href'
        if href then window.Router.navigate href, true

    #'mouseover i[rel="tooltip"]': (e) ->
    #  console.log 'test'
    #  $(e.currentTarget).tooltip()

  nextLevel: (level) ->
    # HACK: this should be some exponential formula.
    # HACK: this should be part of a user model.
    next = 0
    switch level
      when 1 then next = 10
      when 2 then next = 25
      when 3 then next = 125
      when 4 then next = 525
      when 5 then next = 1225
    return next

