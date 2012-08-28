// Generated by CoffeeScript 1.3.3

_.extend(Template.accomplishment, Template.vote, {
  events: {
    'click .add-tag': function(e) {
      Session.set('addingTag', this._id);
      Meteor.flush();
      return focusById('addingTag-' + this._id);
    }
  },
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
    return this.comments;
    c = Comments.find({
      topic: this._id
    });
    if (c) {
      return c.count();
    }
  }
});

_.extend(Template.accomplishment.events, Template.vote.events);
