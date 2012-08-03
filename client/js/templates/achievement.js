// Generated by CoffeeScript 1.3.3
(function() {

  _.extend(Template.achievement, {
    events: {
      'click .expand': function(e) {
        Session.toggle('expand', this._id);
        return Session.set('expandTab', 'info');
      },
      'click .accomplish': function(e) {
        Session.set('expand', this._id);
        return Session.set('expandTab', 'accomplish');
      },
      'click .edit': function(e) {
        Session.set('expand', this._id);
        return Session.set('expandTab', 'edit');
      },
      'click .talk': function(e) {
        Session.set('expand', this._id);
        return Session.set('expandTab', 'talk');
      },
      'click .vote': function(e) {
        var $t, data, vote;
        $t = $(e.target).parents('.vote');
        data = {
          user: Meteor.user()._id,
          entity: this._id,
          up: $t.data('up')
        };
        vote = Votes.findOne({
          user: Meteor.user()._id,
          entity: this._id
        });
        if (vote) {
          Votes.update(vote._id, {
            $set: data
          });
        } else {
          Votes.insert(data);
        }
        return Meteor.call('updateAchievementScore', this._id);
      },
      'click .fav': function(e) {
        var fav;
        fav = Favourites.findOne({
          user: Meteor.user()._id,
          entity: this._id
        });
        if (fav) {
          return Favourites.update(fav._id, {
            $set: {
              active: !fav.active
            }
          });
        } else {
          return Favourites.insert({
            user: Meteor.user()._id,
            entity: this._id,
            active: true
          });
        }
      },
      'click .quest': function(e) {
        var quest;
        quest = Quests.findOne({
          user: Meteor.user()._id,
          entity: this._id
        });
        if (quest) {
          return Quests.update(quest._id, {
            $set: {
              active: !quest.active
            }
          });
        } else {
          return Quests.insert({
            user: Meteor.user()._id,
            entity: this._id,
            active: true
          });
        }
      }
    },
    faved: function() {
      var fav;
      if (Meteor.user()) {
        fav = Favourites.findOne({
          user: Meteor.user()._id,
          entity: this._id,
          active: true
        });
        if (fav) {
          return 'active';
        }
      }
      return '';
    },
    quest: function() {
      var fav;
      if (Meteor.user()) {
        fav = Quests.findOne({
          user: Meteor.user()._id,
          entity: this._id,
          active: true
        });
        if (fav) {
          return 'active';
        }
      }
      return '';
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
    },
    completed: function() {
      var acc;
      if (Meteor.user()) {
        acc = Accomplishments.findOne({
          user: Meteor.user()._id,
          entity: this._id
        });
        if (acc) {
          return 'completed';
        }
      }
      return '';
    }
  });

}).call(this);
