// Generated by CoffeeScript 1.3.3
(function() {

  _.extend(Template.favourites, {
    select: function() {
      var sel;
      sel = {};
      sel.created = true;
      if (Session.get('category') != null) {
        sel.category = Session.get('category');
      }
      return sel;
    },
    favourites: function() {
      var data, sort, user, username;
      sort = Session.get('sort');
      switch (sort) {
        case 'hot':
          data = {
            score: -1
          };
          break;
        case 'cool':
          data = {
            score: 1
          };
          break;
        case 'new':
          data = {
            date: -1
          };
          break;
        case 'old':
          data = {
            date: 1
          };
          break;
        case 'best':
          data = {
            score: -1
          };
          break;
        case 'wort':
          data = {
            score: 1
          };
      }
      username = Session.get('username');
      if (username) {
        user = Meteor.users.findOne({
          username: username
        });
        if (user) {
          return Favourites.find({
            user: user._id,
            active: true
          }, {
            sort: data
          });
        }
      }
    },
    achievement: function() {
      var acc, sel;
      sel = {};
      sel._id = this.entity;
      if (Session.get('category') != null) {
        sel.category = Session.get('category');
      }
      if (Session.equals('menu', 'questlog')) {
        acc = Accomplishments.findOne({
          user: Meteor.user()._id,
          entity: this.entity
        });
        if (acc) {
          return false;
        }
      }
      return Achievements.findOne(sel);
    },
    achievements: function() {
      var a, data, sel, sort;
      sel = Template.achievements.select();
      sort = Session.get('sort');
      switch (sort) {
        case 'hot':
          data = {
            score: -1
          };
          break;
        case 'cool':
          data = {
            score: 1
          };
          break;
        case 'new':
          data = {
            date: -1
          };
          break;
        case 'old':
          data = {
            date: 1
          };
          break;
        case 'best':
          data = {
            score: -1
          };
          break;
        case 'wort':
          data = {
            score: 1
          };
      }
      a = Achievements.find(sel, {
        sort: data
      });
      return a;
    }
  });

}).call(this);
