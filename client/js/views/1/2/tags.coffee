_.extend Template.tags,
  events:
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
          Session.set 'addingTag', null

        cancel:
          Session.set 'addingTag', null

    #'click .remove': (e) ->
    #  $t = $(e.target).closest '.tag'
    #  tag = $t.data 'tag'
    #  @tags = _.without @tags, tag
    #  Session.get 'redraw'

  addingTag: ->
    Session.get 'redraw'
    return Session.equals 'addingTag', @_id

  tag: ->
    return this
