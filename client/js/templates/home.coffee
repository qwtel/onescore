_.extend Template.home,
  accomplishments: ->
    sort = Session.get 'sort'

    switch sort
      when 'hot' then data = score: -1
      when 'cool' then data = score: 1

      when 'new' then data = date: -1
      when 'old' then data = date: 1

      when 'best' then data = score: -1
      when 'wort' then data = score: 1

    return Accomplishments.find
      story: $exists: true
      #story: $ne: ''
    ,
      sort: data
