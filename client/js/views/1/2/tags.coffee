_.extend Template.tags,
  events:
    'click .add': (e) ->
      Session.set 'addingTag', @_id
      Meteor.flush()
      focusById 'addingTag-'+@_id

    'keyup .edittag-input,  keydown .edittag-input':
      makeOkCancelHandler
        ok: (text, e) ->
          unless @tags
            @tags = []

          text = text.replace(///\s///g,'')
          @tags = _.union @tags, [text]

          collection = @collection or @type
          Collections[collection].update @_id,
            $set:
              tags: @tags

          Session.set 'addingTag', null

        cancel:
          Session.set 'addingTag', null

    'click .remove': (e) ->
      window.Collections[@entityType].update @entity,
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

  isActive: (name, value) ->
    Session.get '_'+name
    field = Session.get name
    return if _.contains field, value then 'active' else ''

  addingTag: ->
    Session.get 'redraw'
    return Session.equals 'addingTag', @_id
