// Generated by CoffeeScript 1.3.3

Meteor.subscribe('users');

Meteor.subscribe('comments');

Meteor.subscribe('votes');

Meteor.subscribe('favourites');

Meteor.subscribe('accomplishments');

Meteor.subscribe('titles');

Meteor.autosubscribe(function() {
  var batch, sel, sort;
  sel = Template.filter.select();
  sort = Template.filter.sort();
  batch = Session.get('skip');
  return Meteor.subscribe('achievements', sel, sort, batch);
});

Meteor.autosubscribe(function() {
  var batch;
  batch = Session.get('skip');
  return Meteor.subscribe('notifications', batch);
});

Meteor.autosubscribe(function() {
  var batch, id;
  id = Session.get('single');
  batch = Session.get('skip');
  return Meteor.subscribe('revisions', id, batch);
});
