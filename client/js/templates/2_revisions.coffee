_.extend Template.revisions,
  events:
    'click .restore': (e) ->
      Meteor.call 'restore', this

  revisions: ->
    test = Revisions.find entity: @_id
    revisions = Revisions.find
      entity: @_id
    ,
      eort: date: -1
      limit: 5*(Session.get('skip')+1)

    if test.count() is 0 then false else revisions

  user: ->
    return Meteor.users.findOne @user

  tagItems: ->
    tagItems = []
    _.each @tags.added, (tag) =>
      tagItems.push
        tag: "- "+tag
        entity: @_id
        entityType: @type

    _.each @tags.removed, (tag) =>
      tagItems.push
        tag: "+ "+tag
        entity: @_id
        entityType: @type

    return tagItems
