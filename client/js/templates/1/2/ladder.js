// Generated by CoffeeScript 1.3.3
(function() {

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
          score: -1,
          _id: -1
        }
      });
    }
  });

}).call(this);