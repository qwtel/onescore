Backbone.sync = (method, model, options) ->
  # Default options, unless specified.
  options or (options = {})

  # Ensure that we have a URL.
  unless model.url
    throw new Error 'whatever'

  collection = Collections[model.url]

  unless collection
    throw new Error 'whatever'

  switch methods
    when 'create'
      collection.insert model.toJSON()
    when 'update'
      collection.update model.id, model.toJSON()
    when 'delete'
      collection.remove model.id
    when 'read'
      collection.findOne model.id

class Meteor.Model extends Backbone.Model
  idAttribute: '_id'
