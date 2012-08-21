_.extend Template.accomplish,
  events:
    'click .create': (e) ->
      unless e.isPropagationStopped()
        e.stopPropagation()

        story = $("#editor-#{@_id}").val()
        data =
          entity: @_id
          entityType: 'achievement'
          story: story

        Meteor.call 'accomplish', data, (error, result) ->
          window.Router.navigate "/accomplishments/#{result}", true

        Session.set 'modal', @_id

    'click .uncreate': (e) ->
      Accomplishments.remove @_id

    'click a.editor': (e) ->
      $('.editor').hide()
      $('.preview').show()

    'click a.preview': (e) ->
      $('.editor').show()
      $('.preview').hide()

  accomplishment: ->
    Accomplishments.findOne
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
 
  callback: ->
    Meteor.setTimeout =>
      $("#editor-#{@_id}").markdownEditor
        toolbarLoc: $("#toolbar-#{@_id}")
        toolbar: "default"
        preview: $("#preview-#{@_id}")
    ,
      0
    return ''
