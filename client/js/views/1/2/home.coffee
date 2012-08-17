_.extend Template.home,
  accomplishments: ->
    sort = Template.filter.sort()

    return Accomplishments.find {},
      sort: sort
