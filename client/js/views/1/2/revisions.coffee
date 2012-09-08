_.extend Template.revisions,
  revisions: ->
    Revisions.find
      entity: @_id
    ,
      sort:
        date: -1
