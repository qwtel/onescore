_.extend Template.home,
  accomplishments: ->
    sort = Session.get 'sort'

    switch sort
      when 'hot' then data = hot: -1
      when 'cool' then data = hot: 1

      when 'new' then data = date: -1
      when 'old' then data = date: 1

      when 'best' then data = best: -1
      when 'worst' then data = best: 1

    return Accomplishments.find
      story: $exists: true
      #story: $ne: ''
    ,
      sort: data
