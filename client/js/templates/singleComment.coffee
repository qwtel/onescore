_.extend Template.singleComment,
  events:
    'click .edit': (e) ->
      unless e.isPropagationStopped()
        e.stopPropagation()
        Session.set 'addComment', null
        Session.toggle 'editComment', @_id
        #Session.set 'thread', window.getThreadId(this)
        Meteor.flush()
        window.focusById "edit-#{@_id}"

    'click .vote': (e) ->
      unless e.isPropagationStopped()
        e.stopPropagation()
        $t = $(e.target)
        unless $t.hasClass 'vote' then $t = $t.parents '.vote'
        up = $t.data 'up'
        Meteor.call 'vote', 'comments', @_id, up

    'click .remove': (e) ->
      unless e.isPropagationStopped()
        e.stopPropagation()
        Comments.remove @_id

    'click .link': (e) ->
      unless e.isPropagationStopped()
        e.stopPropagation()
        Session.set 'parent', @_id
        Session.set 'level', @level

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
          url: "/#{comment.type}/#{comment.topic}"

    return breadcrumbs.reverse()

  user: ->
    return Meteor.users.findOne @user

  mention: ->
    if @mention
      return Meteor.users.findOne @mention

  verb: ->
    if @parent?
      return 'replied'
    return 'commented'

  addLineBreaks: (text) ->
    text = _.escape text
    return text.replace '\n', '<br>'

  voted: (state) ->
    state = if state is 'up' then true else false

    if Meteor.user()
      vote = Votes.findOne
        user: Meteor.user()._id
        entity: @_id
      if vote and vote.up is state
        return 'active'
    return ''

