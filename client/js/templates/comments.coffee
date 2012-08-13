_.extend Template.comments,
  events:
    'click .new': (e) ->
      Session.set 'addComment', 'new'
      Meteor.flush()
      window.focusById "add-#{@_id}"

    'keyup .new-thread,  keydown .new-thread':
      window.makeOkCancelHandler
        ok: (text, e) ->
          parent = Session.get 'parent'
          if parent
            level = 1 + Session.get 'level'
          else
            level = 0

          Comments.insert
            text: text
            date: new Date
            topic: Session.get 'single'
            parent: parent
            #mention: parent
            user: Meteor.user()._id
            score: 0
            level: level

          Session.set 'addComment', null
          Session.set 'editComment', null
          e.target.value = ""

    'keyup .comment-text, keydown .comment-text':
      window.makeOkCancelHandler
        ok: (text, e) ->
          if Session.get('addComment') isnt null
            Comments.insert
              text: text
              date: new Date
              topic: Session.get 'single'
              parent: @_id
              mention: @user
              user: Meteor.user()._id
              score: 0
              level: @level+1

          Session.set 'addComment', null
          Session.set 'editComment', null
          e.target.value = ""

     'keyup .edit-text, keydown .edit-text':
      window.makeOkCancelHandler
        ok: (text, e) ->
          if Session.equals 'editComment', @_id
            Comments.update @_id,
              $set:
                text: text

          Session.set 'addComment', null
          Session.set 'editComment', null
          e.target.value = ""

     'click .back': (e) ->
       unless e.isPropagationStopped()
         e.stopPropagation()
         $t = $(e.target).closest '.back'
         id = $t.data 'id'
         level = $t.data 'level'
         if id and level
           Session.set 'parent', $t.data('id')
           Session.set 'level', $t.data('level')
         else
           Session.set 'parent', null
           Session.set 'level', null

  select: (id) ->
    sel =
      topic: Session.get 'single'
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
      when 'hot' then data = score: -1
      when 'cool' then data = score: 1

      when 'new' then data = date: -1
      when 'old' then data = date: 1

      when 'best' then data = score: -1
      when 'wort' then data = score: 1

    c = Comments.find sel,
      sort: data
    return c

  user: ->
    return Meteor.users.findOne @user

  breadcrumbs: ->
    comments = []
    parent = Session.get 'parent'
    if parent
      comment = Comments.findOne parent
      comments.push comment
      while comment.parent isnt null
        comment = Comments.findOne comment.parent
        comments.push comment
    return comments.reverse()
