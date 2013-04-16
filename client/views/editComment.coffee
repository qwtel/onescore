Template.editComment.events
  'click .edit-comment': (e) ->
    $t = $(e.currentTarget).parents('.pill')
    text = $t.find(".edit-#{@_id}").val()
    if text isnt ''
      Meteor.call 'editComment', @_id, text
    Session.set "edit", null

#Template.newStory.created = ->
#  val = $(@find('textarea')).val()
#  length = if val then val.length else 0
#  Session.set 'length', length
