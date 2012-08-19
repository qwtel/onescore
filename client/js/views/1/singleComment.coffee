_.extend Template.singleComment, Template.comment,
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
  'click .replyy': (e) ->
    Session.toggle 'addComment', 'new'
    Meteor.flush()
    window.focusById "add-#{@_id}"
