_.extend Template.tagFilter,
  events:
    'click .tag': (e) ->
      if Session.equals 'tagFilter', @tag
        Session.set 'tagFilter', null
      else
        Session.set 'tagFilter', @tag

  tags: ->

    if Session.equals 'page', 'activities'
      sel = Template.activities.select()
      entities = Activities.find(sel)
    else if Session.equals 'page', 'slides'
      sel = Template.slideshows.select()
      entities = Slideshows.find(sel)

    tagInfos = []

    entities.forEach (activity) ->
      _.each activity.tags, (tag) ->
        tagInfo = _.find tagInfos, (x) ->
          return (x.tag is tag)
        if not tagInfo
          tagInfos.push
            tag: tag
            count: 1
        else
          tagInfo.count++

    tagInfos = _.sortBy tagInfos, (x) ->
      return x.tag

    return tagInfos

