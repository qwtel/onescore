_.extend Template.home,
  accomplishments: ->
    sort = Template.filter.sort()
    sel = Template.accomplishments.select()
    return Accomplishments.find sel,
      sort: sort
      limit: 15*(Session.get('skip')+1)
