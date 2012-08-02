_.extend Template.comment,
  events:
    'click .reply': (e) ->
      Session.set 'add-comment', @_id
      Session.set 'edit-comment', null
      Session.set 'thread', window.getThreadId(this)
      Meteor.flush()
      window.focusById "reply-#{@_id}"

    'click .like': (e) ->
      Comments.update @_id,
        $push:
          likes: Session.get 'user'

    'click .unlike': (e) ->
      Comments.update @_id,
        $pull:
          likes: Session.get 'user'

    'click .edit': (e) ->
      Session.set 'add-comment', null
      Session.set 'edit-comment', @_id
      Session.set 'thread', window.getThreadId(this)
      Meteor.flush()
      window.focusById "reply-#{@_id}"

    'click .remove': (e) ->
      Comments.remove @_id

  addComment: ->
    return Session.equals 'add-comment', @_id

  editComment: ->
    return Session.equals 'edit-comment', @_id
  
  formatDate: (date) ->
    d = moment(new Date(@date))
    return d.format "DD.MM.YYYY, hh:mm"

  likesNum: ->
    return if @likes? then @likes.length else 0
  
  nested: ->
    return if @parent then 'nested' else ''
  
  addLineBreaks: (text) ->
    text = _.escape text
    return text.replace '\n', '<br>'

  mention: ->
    if @mention isnt null
      return "@#{window.getUsername(@mention)}:"

