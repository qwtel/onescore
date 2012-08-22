_.extend Template.tags,
  events:
    #'click .tag': (e) ->
    #  Session.toggle 'tagFilter', @tag

    'click .add': (e) ->
      Session.set 'addingTag', @_id
      Meteor.flush()
      focusById('addingTag-'+@_id)

    'keyup .edittag-input,  keydown .edittag-input':
      makeOkCancelHandler
        ok: (text, e) ->
          unless @tags
            @tags = []

          text = text.replace(///\s///g,'')
          @tags = _.union @tags, [text]

          window.table[@type].update @_id,
            $set:
              tags: @tags

          Session.set 'addingTag', null

        cancel:
          Session.set 'addingTag', null

    'click .remove': (e) ->
      e.stopPropagation()
      window.table[@entityType].update @entity,
        $pull:
          tags: @tag

  tagObjects: ->
    tagObjects = []
    _.each @tags, (tag) =>
      tagObjects.push
        tag: tag
        entity: @_id
        entityType: @type
    return tagObjects

  addingTag: ->
    Session.get 'redraw'
    return Session.equals 'addingTag', @_id
