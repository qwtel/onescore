_.extend Template.comments,
  events:
    'keyup .comment-text, keydown .comment-text, 
     keyup .edit-text, keydown .edit-text':
      window.makeOkCancelHandler
        ok: (text, e) ->
          if Session.get('add-comment') isnt null
            Comments.insert
              text: text
              date: new Date
              topic: Session.get 'expand'
              parent: Session.get 'thread'
              mention: @user
              user: Meteor.user()._id

          else if Session.equals 'edit-comment', @_id
            Comments.update @_id,
              $set:
                text: text

          Session.set 'add-comment', null
          Session.set 'edit-comment', null
          e.target.value = ""

  select: (id) ->
    sel =
      topic: Session.get 'expand'
      parent: null
    
    if id
      sel.parent = id

    else
      if Session.equals 'comment-filter', 'my'
        sel.user = Session.get 'user'

      else if Session.equals 'comment-filter', 'lva'
        sel.user = $lt: 2000000

    return sel

  comments: ->
    sel = Template.comments.select()
    return Comments.find sel,
      sort:
        date: -1

  replies: ->
    sel = Template.comments.select(@_id)
    return Comments.find sel,
      sort:
        date: 1

  noContent: ->
    console.log 'tasdf<'
    if Session.equals 'commentsLoaded', true
      sel = Template.comments.select()
      return Comments.find(sel).count() is 0
    return false

