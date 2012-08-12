_.extend Template.accomplish,
  events:
    'click .create': (e) ->
      stry = $("#editor-#{@_id}").val()
      Session.set 'expand', null
      Meteor.call 'accomplish', @_id, stry

    'click .uncreate': (e) ->
      Accomplishments.remove @_id

    #'click .preview': (e) ->
    #  Session.toggle 'preview', true
    #  if Session.get('preview') is true
    #    $('#preview').show()
    #    $('#editor').hide()
    #  else
    #    $('#preview').hide()
    #    $('#editor').show()
    #  Meteor.flush()
    #  $("#editor-#{@_id}").markdownEditor
    #    toolbarLoc: $('#toolbar')
    #    toolbar: 'default'
    #    preview: $('#preview')

    'click .text': (e) ->
      Session.toggle 'story', 'text'
    'click .picture': (e) ->
      Session.toggle 'story', 'picture'

    'click .link': (e) ->
      Session.toggle 'story', 'link'

  accomplishment: ->
    return Accomplishments.findOne
      user: Meteor.user()._id
      entity: @_id

  story: ->
    acpl = Accomplishments.findOne
      user: Meteor.user()._id
      entity: @_id
    if acpl
      if acpl.story
        return acpl.story
    return ''
