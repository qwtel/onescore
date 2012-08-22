_.extend Template.tagFilter,
  events:
    'click .tag': (e) ->
      Session.toggle 'tagFilter', @tag

  tags: ->
    page = Session.get 'page'
    collection = window.table[page]

    if collection
      tagInfos = []
      collection.find().forEach (entity) ->
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

