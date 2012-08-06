_.extend Template.comment,
  events:
    'click .reply': (e) ->
      Session.toggle 'add-comment', @_id
      Session.set 'edit-comment', null
      Session.set 'thread', window.getThreadId(this)
      Meteor.flush()
      window.focusById "reply-#{@_id}"

    'click .vote': (e) ->
      unless e.isPropagationStopped()
        $t = $(e.target)
        unless $t.hasClass 'vote' then $t = $t.parents '.vote'
        up = $t.data 'up'
        Meteor.call 'vote', 'comments', @_id, up
        e.stopPropagation()

    #'click .like': (e) ->
    #  Comments.update @_id,
    #    $push:
    #      likes: Session.get 'user'
    #
    #'click .unlike': (e) ->
    #  Comments.update @_id,
    #    $pull:
    #      likes: Session.get 'user'

    'click .edit': (e) ->
      Session.set 'add-comment', null
      Session.toggle 'edit-comment', @_id
      Session.set 'thread', window.getThreadId(this)
      Meteor.flush()
      window.focusById "reply-#{@_id}"

    'click .remove': (e) ->
      Comments.remove @_id

  user: ->
    return Meteor.users.findOne @user

  mention: ->
    if @mention
      return Meteor.users.findOne @mention

  verb: ->
    if @parent?
      return 'replied to'
    return 'commented'

  nested: ->
    return if @parent then 'nested' else ''
  
  addLineBreaks: (text) ->
    text = _.escape text
    return text.replace '\n', '<br>'

  voted: (state) ->
    state = if state is 'up' then true else false

    if Meteor.user()
      vote = Votes.findOne
        user: Meteor.user()._id
        entity: @_id
      if vote and vote.up is state
        return 'active'
    return ''
