// Generated by CoffeeScript 1.3.3

_.extend(Template.ladder, {
  select: function() {
    var sel;
    sel = {};
    return sel;
  },
  users: function() {
    var sel;
    sel = Template.ladder.select();
    return Meteor.users.find(sel, {
      sort: {
        score: 1,
        date: 1
      },
      limit: 25 * (Session.get('skip') + 1)
    });
  }
});
