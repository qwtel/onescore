creator = (userId, entities) ->
  return _.all entities, (entity) ->
    return not entity.user or entity.user is userId

self = (userId, doc) ->
  return userId is doc.user

unique = (Collection, userId, doc) ->
  if self(userId, doc)
    duplicate = Collection.findOne
      entity: doc.entity
      user: doc.user

     if not duplicate
       return true

  return false

uniqueVote = (userId, doc) ->
  return unique Votes, userId, doc

uniqueFav = (userId, doc) ->
  return unique Favourites, userId, doc

uniqueQuest = (userId, doc) ->
  return unique Quests, userId, doc

uniqueAcc = (userId, doc) ->
  return unique Accomplishments, userId, doc

Meteor.startup ->
  ###
  Todos.allow
    insert: -> return true
    update: canModify
    remove: canModify
    fetch: ['privateTo']
  ###

  #Meteor.users.allow
  #  insert: -> return true
  #  update: -> return true
  #  remove: -> return true

  Notifications.allow
    insert: -> return true
    update: -> return true
    remove: -> return true

  Revisions.allow
    insert: -> return true
    update: -> return true
    remove: -> return true

  #Skills.allow
  #  insert: -> return true
  #  update: -> return true
  #  remove: -> return true

  Achievements.allow
    insert: self
    update: creator
  # remove: -> return true

  Titles.allow
    insert: self
  # update: creator

  #Votes.allow
  #  insert: uniqueVote
  #  update: creator

  Favourites.allow
    insert: uniqueFav
    update: creator

  #Quests.allow
  #  insert: uniqueQuest
  #  update: creator

  Accomplishments.allow
    insert: uniqueAcc
    update: -> return true
    remove: self

  #Comments.allow
  #  insert: self
  #  update: creator
  #  remove: -> return true
