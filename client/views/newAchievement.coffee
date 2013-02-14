Template.newAchievement.helpers
  parentAchievement: -> 
    id = Session.get 'parentAchievement'
    if id then Achievements.findOne id

  newAchievement: -> 
    Scratchpad.findOne type: 'achievement'

Template.newAchievement.destroyed = ->
  Scratchpad.remove type: 'achievement'

Template.newAchievement.events
  'change input, change textarea': (e) ->
    $t = $(e.currentTarget)
    field = $t.data('field') 
    data = {}
    data[field] = $t.val()

    Scratchpad.update @_id, $set: data

  'click #new-achievement': (e) ->
    data = Scratchpad.findOne @_id

    parent = Session.get 'parentAchievement'
    if parent then data.parent = parent else data.parent = null

    # XXX: I don't like this whole "data-business" any more. Should be formal
    # function parameters, e.g. title, description, parent, etc...
    Meteor.call 'newAchievement', data, (error, result) ->
      unless error
        Router.navigate "achievement/#{result}", true
