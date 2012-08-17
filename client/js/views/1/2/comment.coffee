_.extend Template.comment, Template.vote,
  events:
    'click .reply': (e) ->
      unless e.isPropagationStopped()
        e.stopPropagation()
        Session.toggle 'addComment', @_id
        Session.set 'editComment', null
        Meteor.flush()
        window.focusById "reply-#{@_id}"

    'click .edit': (e) ->
      unless e.isPropagationStopped()
        e.stopPropagation()
        Session.set 'addComment', null
        Session.toggle 'editComment', @_id
        Meteor.flush()
        window.focusById "edit-#{@_id}"

    'click .remove': (e) ->
      unless e.isPropagationStopped()
        e.stopPropagation()
        Comments.remove @_id

    'click .unexpand': (e) ->
      unless e.isPropagationStopped()
        e.stopPropagation()
        Session.push 'unexpand', @_id, true

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

  cutoff: ->
    parent = Session.get 'parent'
    if parent
      return @level > Session.get('level') + 4
    else
      return @level > Session.get('level') + 3

  replies: ->
    sel = Template.comments.select @_id
    sort = Template.filter.sort()

    Comments.find sel,
      sort: sort

_.extend Template.comment.events, Template.vote.events
