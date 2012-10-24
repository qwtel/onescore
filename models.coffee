class Model extends Backbone.Model
  type: 'scratchpad'
  idAttribute: '_id'
  defaults:
    user: ''
    date: new Date()
    score: 0
    hot: 0
    best: 0

  fields: []
  initialize: ->
    @fields = _.keys @defaults

class Notification extends Model
  #type: 'notification'
  defaults:
    _.extend {}, _super::defaults,
      entity: ''
      entityType: ''
      target: ''
      targetType: ''
      receivers: []

  @notify: (entity, target) ->

class Vote extends Model
  #type: 'vote'
  defaults:
    _.extend {}, _super::defaults,
      entity: ''
      entityType: ''
      up: true

  initialize: ->
    super()
    entity = Collections[@type].findOne
      user: @get 'user'
      entity: @get 'entity'

    if entity
      @set '_id', entity._id

  @vote: (data) ->
    vote = new Vote(data)
    vote.save()
    #calcScore() \
    #notify() \
    #hasPermission() \

  validate: (attrs) ->

class Achievement extends Model
  type: 'achievement'
  defaults:
    _.extend {}, _super::defaults,
      value: 0
      comments: 0

class Accomplishment extends Model
  type: 'accomplishment'

class Comment extends Model
  type: 'comment'

class Title extends Model
  type: 'title'

a = new Achievement
