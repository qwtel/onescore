_.extend Template.comment,
  events:
    'click .reply': (e) ->
      unless e.isPropagationStopped()
        e.stopPropagation()
        Session.toggle 'addComment', @_id
        Session.set 'editComment', null
        #Session.set 'thread', window.getThreadId(this)
        Meteor.flush()
        window.focusById "reply-#{@_id}"

    'click .edit': (e) ->
      unless e.isPropagationStopped()
        e.stopPropagation()
        Session.set 'addComment', null
        Session.toggle 'editComment', @_id
        #Session.set 'thread', window.getThreadId(this)
        Meteor.flush()
        window.focusById "edit-#{@_id}"

    'click .vote': (e) ->
      unless e.isPropagationStopped()
        e.stopPropagation()
        $t = $(e.target)
        unless $t.hasClass 'vote' then $t = $t.parents '.vote'
        up = $t.data 'up'
        Meteor.call 'vote', 'comments', @_id, up

    'click .remove': (e) ->
      unless e.isPropagationStopped()
        e.stopPropagation()
        Comments.remove @_id

    'click .unexpand': (e) ->
      unless e.isPropagationStopped()
        e.stopPropagation()
        Session.push 'unexpand', @_id, true

    'click .link': (e) ->
      unless e.isPropagationStopped()
        e.stopPropagation()
        Session.set 'parent', @_id
        Session.set 'level', @level

    'mouseover .highlight': (e) ->
      unless e.isPropagationStopped()
        e.stopPropagation()
        $(e.target).closest('.comment').addClass 'hover'

    'mouseleave .highlight': (e) ->
      unless e.isPropagationStopped()
        e.stopPropagation()
        $(e.target).closest('.comment').removeClass 'hover'

  unexpand: ->
    Session.get 'redraw'
    field = Session.get 'unexpand'
    if field
      return field[@_id]
    return false

  user: ->
    return Meteor.users.findOne @user

  mention: ->
    if @mention
      return Meteor.users.findOne @mention

  verb: ->
    if @parent?
      return 'replied'
    return 'commented'

  hidden: ->
    return false

  nested: ->
    parent = Session.get 'parent'
    if parent
      return if @level-1 > Session.get('level') then 'nested' else ''
    else
      return if @level > Session.get('level') then 'nested' else ''
  
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

  cutoff: ->
    parent = Session.get 'parent'
    if parent
      return @level > Session.get('level') + 5
    else
      return @level > Session.get('level') + 4

  replies: ->
    sel = Template.comments.select @_id
    sort = Session.get 'sort'

    switch sort
      when 'hot' then data = score: -1
      when 'cool' then data = score: 1

      when 'new' then data = date: -1
      when 'old' then data = date: 1

      when 'best' then data = score: -1
      when 'wort' then data = score: 1

    c = Comments.find sel,
      sort: data
    return c
