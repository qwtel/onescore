Template.newStory.events
  'click .add-story': (e) ->
    text = $("#accomplished-#{@_id}").val()
    if text isnt ''
      Meteor.call 'accomplish', @_id, text
    Session.set "accomplished", null

  'keydown textarea': (e) ->
    length = $(e.currentTarget).val().length
    Session.set 'length', length

#Template.newStory.created = ->
#  val = $(@find('textarea')).val()
#  length = if val then val.length else 0
#  Session.set 'length', length

Template.newStory.helpers
  story: ->
    acc = Accomplishments.findOne 
      user: Meteor.userId()
      entity: @_id
    if acc then acc.story else ''

  remainingChars: ->
    140 - (Session.get('length') or 0)
