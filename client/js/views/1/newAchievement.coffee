_.extend Template.newAchievement, Template.edit,
  newAchievement: ->
    newAchievement = Scratchpad.findOne
      type: 'achievement'

    if newAchievement
      id = newAchievement._id
    else
      data =
        user: Meteor.user()._id
        date: new Date().getTime()
        score: 0
        hot: 0
        best: 0
        value: 0
        comments: 0

      data.type = 'achievement'
      data.collection = 'scratchpad'
      id = Scratchpad.insert data

    return Scratchpad.findOne id

Template.newAchievement.events = _.extend {}, Template.edit.events,
  'click .close': (e) ->
    Session.set 'styleGuide', true

  'change .lazy': (e) ->
    data = {}
    $t = $(e.currentTarget)
    field = $t.data('field') 
    data[field] = $t.val()

    Scratchpad.update @_id, $set: data

  'change .description': (e) ->
    $t = $(e.currentTarget)
    desc = $t.val()
    tags = window.findTags(desc) or []

    if @tags then tags = _.union tags, @tags
    Scratchpad.update @_id, $set: tags: tags

  'click .create': (e) ->
    defaults =
      category: 'random'

    data = Scratchpad.findOne @_id
    data = _.defaults data, defaults
    delete data._id
    id = Achievements.insert data

    if @title
      titleData =
        title: @title
        entity: id

      Meteor.call 'suggestTitle', titleData

    window.Router.navigate "achievements/#{id}", true
