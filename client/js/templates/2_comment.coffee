_.extend Template.comment,
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
        Session.toggle "unexpand-#{@_id}", true

    #'mouseover .highlight': (e) ->
    #  unless e.isPropagationStopped()
    #    e.stopPropagation()
    #    $(e.target).closest('.comment').addClass 'hover'
    #
    #'mouseout .highlight': (e) ->
    #  unless e.isPropagationStopped()
    #    e.stopPropagation()
    #    $(e.target).closest('.comment').removeClass 'hover'

    'keyup .comment-text, keydown .comment-text':
      window.makeOkCancelHandler
        ok: (text, e) ->
          data =
            text: text
            parent: @_id
            topic: Session.get 'topic'
            topicType: Session.get 'topicType'

          Meteor.call 'comment', data

          Session.set 'addComment', null
          Session.set 'editComment', null
          e.target.value = ""

    'keyup .edit-text, keydown .edit-text':
      window.makeOkCancelHandler
        ok: (text, e) ->
          data =
            _id: @_id
            text: text

          Meteor.call 'comment', data

          Session.set 'addComment', null
          Session.set 'editComment', null
          e.target.value = ""

  unexpand: ->
    Session.equals "unexpand-#{@_id}", true

  verb: ->
    if @parent?
      return 'replied'
    return 'commented'

  nested: ->
    parent = Session.get 'parent'
    if parent
      return if @level-1 > Session.get('level') then 'nested' else ''
    else
      return if @level > Session.get('level') then 'nested' else ''
  
  cutoff: ->
    parent = Session.get 'parent'
    if parent
      return @level > Session.get('level') + 2
    else
      return @level > Session.get('level') + 1


  user: ->
    return Meteor.users.findOne @user

  mention: ->
    if @mention
      return Meteor.users.findOne @mention

  replies: ->
    sel = Template.comments.select @_id
    sort = Template.filter.sort()

    Comments.find sel,
      sort: sort
      limit: 3
