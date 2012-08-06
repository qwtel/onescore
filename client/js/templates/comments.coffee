_.extend Template.comments,
  events:
    'keyup .new-thread,  keydown .new-thread':
      window.makeOkCancelHandler
        ok: (text, e) ->
          Comments.insert
            text: text
            date: new Date
            topic: Session.get 'single'
            parent: null
            mention: null
            user: Meteor.user()._id
            score: 0

          Session.set 'add-comment', null
          Session.set 'edit-comment', null
          e.target.value = ""

    'keyup .comment-text, keydown .comment-text, 
     keyup .edit-text, keydown .edit-text':
      window.makeOkCancelHandler
        ok: (text, e) ->
          if Session.get('add-comment') isnt null
            Comments.insert
              text: text
              date: new Date
              topic: Session.get 'single'
              parent: Session.get 'thread'
              mention: @user
              user: Meteor.user()._id
              score: 0

          else if Session.equals 'edit-comment', @_id
            Comments.update @_id,
              $set:
                text: text

          Session.set 'add-comment', null
          Session.set 'edit-comment', null
          e.target.value = ""

  select: (id) ->
    sel =
      topic: Session.get 'single'
      parent: null
    
    if id
      sel.parent = id

    else
      if Session.equals 'comment-filter', 'my'
        sel.user = Session.get 'user'

    return sel

  comments: ->
    sort = Session.get 'sort'

    switch sort
      when 'hot' then data = score: -1
      when 'cool' then data = score: 1

      when 'new' then data = date: -1
      when 'old' then data = date: 1

      when 'best' then data = score: -1
      when 'wort' then data = score: 1

    sel = Template.comments.select()
    return Comments.find sel,
      sort: data

  replies: ->
    sel = Template.comments.select @_id
    return Comments.find sel,
      sort:
        date: 1

  noContent: ->
    console.log 'tasdf<'
    if Session.equals 'commentsLoaded', true
      sel = Template.comments.select()
      return Comments.find(sel).count() is 0
    return false
