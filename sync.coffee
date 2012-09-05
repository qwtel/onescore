Backbone.sync =
  (method, model, options) ->
    options or (options = {})

    unless(collection = Collections[model.type])
      throw new Error 'whatever'

    switch method
      when 'create'
        id = collection.insert model.toJSON()
        attrs = collection.findOne id
        if attrs
          options.success attrs
        else
          options.error model

      when 'update'
        collection.update model.id, model.toJSON()
        options.success model

      when 'delete'
        collection.remove model.id
        options.success()

      when 'read'
        attrs = collection.findOne model.id
        if attrs
          options.success attrs
        else
          options.error model

