Template.newComment.events
  'click .add-comment': (e) ->
    $t = $(e.currentTarget).parents('.pill')
    text = $t.find(".comment-#{@_id}").val()
    if text isnt ''
      Meteor.call 'comment', @_id, @type, text
    Session.set "comment", null

#Template.newStory.created = ->
#  val = $(@find('textarea')).val()
#  length = if val then val.length else 0
#  Session.set 'length', length

Template.newComment.helpers
  story: ->
    acc = Comments.findOne 
      user: Meteor.userId()
      entity: @_id
    if acc then acc.story else ''
