Template.createNew.events
  'click .create-new': (e) ->
    e.stopImmediatePropagation()
    Session.set 'target', 'new'

    newAchievement = Scratchpad.findOne type: 'achievement'

    # XXX: Well this is kinda in the wrong place
    if not newAchievement 
      data =
        score: 0
        hot: 0
        best: 0
        value: 0
        comments: 0
        upVotes: 0
        votes: 0
        #===
        type: 'achievement'
        title: ''
        parent: if id? then id else null
        description: ''
        favourites: 0
        accomplishments: 0
      Scratchpad.insert data

    Meteor.flush()
    $('.title-input').focus()

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

  'click .btn-create': (e) ->
    Session.set 'target', null
    Meteor.call 'newAchievement', @title, @description, @parent, @imgur,
      (error, result) ->
        unless error
          Session.set 'temp', result
          #Router.navigate "achievement/#{result}", true

Template.createNew.helpers
  parentAchievement: -> 
    id = Session.get 'id'
    if id then Achievements.findOne id

  newAchievement: -> 
    Scratchpad.findOne type: 'achievement'

Template.createNew.destroyed = ->
  Scratchpad.remove type: 'achievement'

Template.createNew.preserve = ['input', 'textarea']
