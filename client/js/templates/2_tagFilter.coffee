_.extend Template.tagFilter,
  events:
    'click .tag': (e) ->
      Session.push 'tagFilter', @tag

  tags: ->
    page = Session.get 'page'

    if Session.equals('menu', 'questlog')
      collection = Template.favourites.achievements()
    else
      collection = Collections[page]
      if collection then collection = collection.find() else return null

    if collection
      tagInfos = []
      collection.forEach (entity) ->
        _.each entity.tags, (tag) ->
          tagInfo = _.find tagInfos, (x) ->
            return (x.tag is tag)
          if not tagInfo
            tagInfos.push
              tag: tag
              count: 1
          else
            tagInfo.count++

      tagInfos = _.sortBy tagInfos, (x) ->
        return -x.count

      return tagInfos

