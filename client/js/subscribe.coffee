Meteor.subscribe 'users'

Meteor.subscribe 'comments'

Meteor.subscribe 'votes'

Meteor.subscribe 'favourites'

Meteor.subscribe 'achievements'

Meteor.subscribe 'accomplishments'

Meteor.autosubscribe ->
  id = Session.get 'single'
  Meteor.subscribe 'titles', id

Meteor.autosubscribe ->
  #sel = Template.filter.select()
  #sort = Template.filter.sort()
  #batch = Session.get 'skip'
  #Meteor.subscribe 'achievements', sel, sort, batch

Meteor.autosubscribe ->
  batch = Session.get 'skip'
  Meteor.subscribe 'notifications', batch

Meteor.autosubscribe ->
  id = Session.get 'single'
  batch = Session.get 'skip'
  Meteor.subscribe 'revisions', id, batch

#Meteor.autosubscribe ->
#  id = Session.get 'single'
#  if id and Session.equals('page', 'achievements')
#    Meteor.subscribe 'titles', id

#Meteor.subscribe 'quests'
#Meteor.autosubscribe ->
#  sel = Template.filter.select()
#  sort = Template.filter.sort()
#  batch = Session.get 'skip'
#
#  Meteor.subscribe 'explore', sel, sort, batch
