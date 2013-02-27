Template.newComment.events
  'click .add-comment': (e) ->
    text = $("#comment-#{@_id}").val()
    if text isnt ''
      Meteor.call 'comment', @_id, @type, text
    Session.set "comment", null

  'keydown textarea': (e) ->
    length = $(e.currentTarget).val().length
    Session.set 'length', length

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

  remainingChars: ->
    140 - (Session.get('length') or 0)

  typeName: ->
    if @type
      strings @type
    else
      strings 'entity'
