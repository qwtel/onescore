_.extend Template.singleComment, Template.comment,
  topic: ->
    switch @type
      when 'comments'
        collection = Comments
      when 'accomplishments'
        collection = Accomplishments
      when 'achievements'
        collection = Achievements

    if collection
      return collection.findOne @topic

  breadcrumbs: ->
    breadcrumbs = []
    parent = Session.get 'parent'
    if parent
      comment = Comments.findOne parent
      if comment
        while comment.parent isnt null
          comment = Comments.findOne comment.parent
          breadcrumbs.push
            name: Meteor.users.findOne(comment.user).username
            user: comment.user
            url: "/comments/#{comment._id}"
        breadcrumbs.push
          name: 'Topic'
          user: null
          url: "/#{comment.topicType}/#{comment.topic}"

    return breadcrumbs.reverse()

_.extend Template.singleComment.events, Template.comment.events,
  'click .reply': (e) ->
    Session.set 'addComment', 'new'
    Meteor.flush()
    window.focusById "add-#{@_id}"

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

