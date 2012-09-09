_.extend Template.revisions,
  events:
    'click .restore': (e) ->
      Meteor.call 'restore', this

  revisions: ->
    revisions = Revisions.find
      entity: @_id
    ,
      sort:
        date: -1

    if revisions.count() is 0 then false else revisions

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
