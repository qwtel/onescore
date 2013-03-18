Template.newAchievement.events
  'change .input-file': (e) ->
    e.stopImmediatePropagation()

    f = e.target.files[0]
    if not f.type.match ///^image/.+///
      return
  
    reader = new FileReader()
    reader.onload = ((file) =>
      return (e) =>
        Scratchpad.update @_id, $set: source: e.target.result

        Meteor.http.post "https://api.imgur.com/3/upload", 
          contentType: 'multipart/form-data'
          content: file
          headers: 'Authorization': 'Client-ID 08d10aaf84947ac'
        ,
          (error, result) =>
            unless error
              Scratchpad.update @_id, 
                $set: 
                  imgur: result.data.data
                  source: result.data.data.link
    )(f)
    reader.readAsDataURL(f)

  'change input, change textarea': (e) ->
    $t = $(e.currentTarget)
    field = $t.data('field') 
    data = {}
    data[field] = $t.val()
    Scratchpad.update @_id, $set: data

  'click #new-achievement': (e) ->
    data = Scratchpad.findOne @_id

    Meteor.call 'newAchievement', @title, @description, @parent, @imgur,
      (error, result) ->
        unless error
          Router.navigate "achievement/#{result}", true

Template.newAchievement.helpers
  parentAchievement: -> 
    id = Session.get 'id'
    if id then Achievements.findOne id

  newAchievement: -> 
    Scratchpad.findOne type: 'achievement'

Template.newAchievement.destroyed = ->
  Scratchpad.remove type: 'achievement'

