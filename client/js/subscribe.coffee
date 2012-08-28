Meteor.subscribe 'users'

Meteor.subscribe 'comments'

Meteor.subscribe 'votes'

Meteor.subscribe 'favourites'

Meteor.subscribe 'achievements'

Meteor.subscribe 'accomplishments'

Meteor.subscribe 'notifications'

#Meteor.subscribe 'quests'

Meteor.autosubscribe ->
  id = Session.get 'single'
  if id and Session.equals('page', 'achievements')
    Meteor.subscribe 'titles', id

#Meteor.autosubscribe ->
#  sel = Template.filter.select()
#  sort = Template.filter.sort()
#  batch = Session.get 'skip'
#
#  sel.created = true
#  Meteor.subscribe 'explore', sel, sort, batch
