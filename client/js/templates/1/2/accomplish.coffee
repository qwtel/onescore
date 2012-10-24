_.extend Template.accomplish,
  events:
    'click .create': (e) ->
      unless e.isPropagationStopped()
        e.stopPropagation()

        story = $("#editor").val()
        @tags or (@tags = [])
        data =
          entity: @_id
          entityType: 'achievement'
          story: story
          tags: @tags

        Meteor.call 'accomplish', data, (error, result) ->
          window.Router.navigate "/accomplishments/#{result}", true

        Session.set 'modal', @_id

    'click .uncreate': (e) ->
      Accomplishments.remove @_id

    'click a.editor': (e) ->
      console.log 'test'
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
 
  # TODO: Use new Spark features to include markdown editor
  rendered: ->
    $('#editor').markdownEditor
      toolbarLoc: $("#toolbar")
      toolbar: "default"
      preview: $("#preview")
