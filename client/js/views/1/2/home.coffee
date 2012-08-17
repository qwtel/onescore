_.extend Template.home,
  accomplishments: ->
    sort = Template.filter.sort()

    return Accomplishments.find
      story: $exists: true
      #story: $ne: ''
    ,
      sort: sort
