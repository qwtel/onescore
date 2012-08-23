// Generated by CoffeeScript 1.3.3

Meteor.publish('users', function() {
  return Meteor.users.find();
});

Meteor.publish('comments', function() {
  return Comments.find();
});

Meteor.publish('achievements', function() {
  return Achievements.find();
});

Meteor.publish('titles', function(entity) {
  return Titles.find({
    entity: entity
  });
});

Meteor.publish('votes', function() {
  return Votes.find();
});

Meteor.publish('favourites', function() {
  return Favourites.find();
});

Meteor.publish('accomplishments', function() {
  return Accomplishments.find();
});

Meteor.publish('notifications', function() {
  return Notifications.find({}, {
    sort: {
      date: -1
    },
    limit: 20
  });
});

Meteor.publish('explore', function(sel, sort, page) {
  return Achievements.find(sel, {
    sort: sort,
    skip: 20 * page,
    limit: 20
  });
});

Meteor.publish('activities', function(sel, sort, page) {});
