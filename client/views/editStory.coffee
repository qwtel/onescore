Template.editStory.events
  'click .edit-story': (e) ->
    $t = $(e.currentTarget).parents('.pill')
    text = $t.find(".edit-#{@_id}").val()
    Meteor.call 'setStory', @entity, text
    Session.set "edit", null

  'change .input-file': (e) ->
    e.stopImmediatePropagation()

    f = e.target.files[0]
    if not f.type.match ///^image/.+///
      return
  
    reader = new FileReader()
    reader.onload = ((file) =>
      return (e) =>
        Meteor.http.post "https://api.imgur.com/3/upload", 
          contentType: 'multipart/form-data'
          content: file
          headers: 'Authorization': 'Client-ID 08d10aaf84947ac'
        ,
          (error, result) =>
            unless error
              Meteor.call 'saveImage', @entity, result
    )(f)
    reader.readAsDataURL(f)
