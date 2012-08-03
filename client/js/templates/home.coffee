_.extend Template.home,
  accomplishments: ->
    return Accomplishments.find
      story: $ne: ''
    ,
      sort:
        date: -1
        _id: -1
