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
            topic: Session.get 'topic'
            topicType: Session.get 'page'

          Meteor.call 'comment', data

          Session.set 'addComment', null
          Session.set 'editComment', null
          e.target.value = ""

    'keyup .comment-text, keydown .comment-text':
      window.makeOkCancelHandler
        ok: (text, e) ->
          if Session.get 'addComment' isnt null
            data =
              text: text
              parent: @_id
              topic: Session.get 'topic'
              topicType: Session.get 'page'

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
    sort = Template.filter.sort()

    Comments.find sel,
      sort: sort

  user: ->
    return Meteor.users.findOne @user
