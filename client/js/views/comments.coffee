_.extend Template.comments,
  events:
    'click .new': (e) ->
      Session.set 'addComment', 'new'
      Meteor.flush()
      window.focusById "add-#{@_id}"

    'keyup .new-thread,  keydown .new-thread':
      window.makeOkCancelHandler
        ok: (text, e) ->
          data =
            text: text
            parent: Session.get 'parent'
            type: Session.get 'page'
            topic: Session.get 'topic'

          Meteor.call 'comment', data

          Session.set 'addComment', null
          Session.set 'editComment', null
          e.target.value = ""

    'keyup .comment-text, keydown .comment-text':
      window.makeOkCancelHandler
        ok: (text, e) ->
          if Session.get('addComment') isnt null
            data =
              text: text
              parent: @_id
              type: Session.get 'page'
              topic: Session.get 'topic'

            Meteor.call 'comment', data

          Session.set 'addComment', null
          Session.set 'editComment', null
          e.target.value = ""

     'keyup .edit-text, keydown .edit-text':
      window.makeOkCancelHandler
        ok: (text, e) ->
          if Session.equals 'editComment', @_id
            data =
              _id: @_id
              text: text

            Meteor.call 'comment', data

          Session.set 'addComment', null
          Session.set 'editComment', null
          e.target.value = ""

  select: (id) ->
    sel =
      topic: Session.get 'topic'
      parent: Session.get 'parent'
    
    if id
      sel.parent = id

    if Session.equals 'limit', 'me'
      sel.user = Meteor.user()._id

    if Session.equals 'limit', 'friends'
      sel.user = 'hugo'

    return sel

  comments: ->
    sel = Template.comments.select()
    sort = Session.get 'sort'

    switch sort
      when 'hot' then data = hot: -1
      when 'cool' then data = hot: 1

      when 'new' then data = date: -1
      when 'old' then data = date: 1

      when 'best' then data = best: -1
      when 'worst' then data = best: 1

    c = Comments.find sel,
      sort: data
    return c

  user: ->
    return Meteor.users.findOne @user
