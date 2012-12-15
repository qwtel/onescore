_.extend Template.accomplish,
  events:
    'click .create': (e) ->
      unless e.isPropagationStopped()
        e.stopPropagation()

        data = Scratchpad.findOne
          type: 'accomplishment'
          entity: @_id

        Meteor.call 'accomplish', data, (error, result) ->
          window.Router.navigate "/accomplishments/#{result}", true

        #Session.set 'modal', @_id

    'change .lazy': (e) ->
      data = {}
      $t = $(e.currentTarget)
      field = $t.attr 'name'
      data[field] = $t.val()

      Scratchpad.update @_id, $set: data

    'click .uncreate': (e) ->
      Accomplishments.remove @_id

    'click a.editor': (e) ->
      $('.editor').hide()
      $('.preview').show()

    'click a.preview': (e) ->
      $('.editor').show()
      $('.preview').hide()

    'change #upload': (evt) ->
      #files = evt.target.files
      #formData = new FormData()
      #
      #for f in files
      #  if not f.type.match('image.*')
      #    continue
      #
      #  formData.append f.name, f
      #
      #  reader = new FileReader()
      #  reader.onload = ((theFile) ->
      #    return (e) ->
      #      $img = $('<img/>').attr('src', e.target.result).attr('title', 
      #        _.escape(theFile.name))
      #      $img2 = $img.clone()
      #      $('#thumbnails').html(
      #        $('<li></li>').addClass('span3').append(
      #          $('<div></div>').addClass('thumbnail').append($img)))
      #      $('#list').html($img2)
      #  )(f)
      #  reader.readAsDataURL(f)
      #
      #Meteor.call 'upload', formData, @_id

  newAccomplishment: ->
    Scratchpad.findOne
      type: 'accomplishment'
      entity: Session.get('single')

  accomplishment: ->
    Accomplishments.findOne
      user: Meteor.user()._id
      entity: @_id

  #story: ->
  #  acpl = Accomplishments.findOne
  #    user: Meteor.user()._id
  #    entity: @_id
  #  if acpl
  #    if acpl.story
  #      return acpl.story
  #  return ''
 
  rendered: ->
    $('#editor').markdownEditor
      toolbarLoc: $("#toolbar")
      toolbar: "default"
      preview: $("#preview")
