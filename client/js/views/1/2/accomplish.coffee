_.extend Template.accomplish,
  events:
    'click .create': (e) ->
      stry = $("#editor-#{@_id}").val()
      Session.set 'expand', null
      Meteor.call 'accomplish', @_id, stry, (error, result) ->
        window.Router.navigate "/accomplishments/#{result}", true

    'click .uncreate': (e) ->
      Accomplishments.remove @_id

    'click button.editor': (e) ->
      $('.editor').hide()
      $('.preview').show()

    'click button.preview': (e) ->
      $('.editor').show()
      $('.preview').hide()

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
 
  callback: ->
    Meteor.setTimeout =>
      $("#editor-#{@_id}").markdownEditor
        toolbarLoc: $("#toolbar-#{@_id}")
        toolbar: "default"
        preview: $("#preview-#{@_id}")
    ,
      0
    return ''
