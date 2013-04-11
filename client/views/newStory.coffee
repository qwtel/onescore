Template.newStory.events
  'click .add-story': (e) ->
    $t = $(e.currentTarget).parents('.pill')
    text = $t.find(".accomplished-#{@_id}").val()
    Meteor.call 'accomplish', @_id, text
    Session.set "accomplished", null

  'keydown textarea': (e) ->
    length = $(e.currentTarget).val().length
    Session.set 'length', length

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
              Meteor.call 'saveImage', @_id, result
    )(f)
    reader.readAsDataURL(f)

Template.newStory.helpers
  story: ->
    acc = Accomplishments.findOne 
      user: Meteor.userId()
      entity: @_id
    if acc then acc.story else ''

  remainingChars: ->
    140 - (Session.get('length') or 0)

#Template.newStory.created = ->
#  val = $(@find('textarea')).val()
#  length = if val then val.length else 0
#  Session.set 'length', length

