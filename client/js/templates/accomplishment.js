// Generated by CoffeeScript 1.3.3
(function() {

  _.extend(Template.accomplishment, {
    events: {
      'click .vote': function(e) {
        var $t, up;
        if (!e.isPropagationStopped()) {
          $t = $(e.target);
          if (!$t.hasClass('vote')) {
            $t = $t.parents('.vote');
          }
          up = $t.data('up');
          Meteor.call('vote', 'accomplishments', this._id, up);
          return e.stopPropagation();
        }
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
      if (this.story !== '') {
        return 'posted';
      } else {
        return 'accomplished';
      }
    },
    voted: function(state) {
      var vote;
      state = state === 'up' ? true : false;
      if (Meteor.user()) {
        vote = Votes.findOne({
          user: Meteor.user()._id,
          entity: this._id
        });
        if (vote && vote.up === state) {
          return 'active';
        }
      }
      return '';
    }
  });

}).call(this);
