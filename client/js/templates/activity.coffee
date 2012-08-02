_.extend Template.activity,
  events:
    'click .open': (e) ->
      if @_id
        window.Router.navigate 'activities/show/'+@_id, true

    'click .edit': (e) ->
      if @_id
        window.Router.navigate 'activities/edit/'+@_id, true

    'click .like': (e) ->
      Activities.update @_id,
        $push:
          likes: Session.get 'user'

    'click .unlike': (e) ->
      Activities.update @_id,
        $pull:
          likes: Session.get 'user'

    'click .up': (e) ->
      if not @votes or not (Session.get('user') in @votes)
        Activities.update @_id,
          $inc:
            score: 1
          $push:
            votes: Session.get 'user'

    'click .down': (e) ->
      if not @votes or not (Session.get('user') in @votes)
        Activities.update @_id,
          $inc:
            score: -1
          $push:
            votes: Session.get 'user'

    'click .remove': (e) ->
      Drafts.remove
        activity: @_id
        user: Session.get 'user'
      Activities.remove @_id

    'click .tag': (e) ->
      tag = $(e.target).data 'tag'
      Session.set 'tagFilter', tag

  score: ->
    return if @score > 0 then @score else 0

