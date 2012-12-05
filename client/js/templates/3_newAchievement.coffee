_.extend Template.newAchievement, Template.edit,
  newAchievement: ->
    id = Session.get 'single'
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

  'click .create': (e) ->
    data = Scratchpad.findOne @_id
    Meteor.call 'newAchievement', data, (error, result) ->
      window.Router.navigate "achievements/#{result}", true
