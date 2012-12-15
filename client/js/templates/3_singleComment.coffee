_.extend Template.singleComment, Template.comment,
  events:
    'click .edit': Template.comment.events['click .edit']

    'click .replyy': (e) ->
      Session.toggle 'addComment', 'new'
      Meteor.flush()
      window.focusById "add-#{@_id}"

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
          url: "/#{comment.topicType}/#{comment.topic}/talk"

    return breadcrumbs.reverse()
