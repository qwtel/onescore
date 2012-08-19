// Generated by CoffeeScript 1.3.3
(function() {

  _.extend(Template.accomplishment, Template.vote, {
    achievement: function() {
      var sel;
      sel = {};
      sel._id = this.entity;
      if (Session.get('category') != null) {
        sel.category = Session.get('category');
      }
      return Achievements.findOne(sel);
    },
    user: function() {
      return Meteor.users.findOne(this.user);
    },
    verb: function() {
      return 'accomplished';
    },
    numComments: function() {
      var c;
      c = Comments.find({
        topic: this._id
      });
      if (c) {
        return c.count();
      }
    }
  });

  _.extend(Template.accomplishment.events, Template.vote.events);

}).call(this);