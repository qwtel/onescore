_.extend Template.tags,
  events:
    'click .add': (e) ->
      if @_id
        Session.set 'addingTag', @_id
      else
        Session.set 'addingTag', 'new'
      Meteor.flush()
      window.focusById('edittag-'+@_id)

    'click .remove': (e) ->
      id = $(e.target).attr('id')
      if id isnt ''
        if Session.equals 'page', 'activities'
          Activities.update id,
            $pull:
              tags: @tag

    'keyup .edittag-input,  keydown .edittag-input':
      window.makeOkCancelHandler
        ok: (text, e) ->
          unless @tags
            @tags = []

          unless _.contains @tags, text
            @tags.push text

          Session.set 'addingTag', null
          if Session.equals 'page', 'activities'
            Activities.update @_id,
              $set:
                tags: @tags

  tags: ->
    tagInfos = []

    _.each @tags, (tag) ->
      tagInfo = _.find tagInfos, (x) ->
        return (x.tag is tag)
      if not tagInfo
        tagInfos.push
          tag: tag

    tagInfos = _.sortBy tagInfos, (x) ->
      return x.tag

    return tagInfos

  addingTag: ->
    if @_id
      return Session.equals 'addingTag', @_id
    else
      return Session.equals 'addingTag', 'new'

