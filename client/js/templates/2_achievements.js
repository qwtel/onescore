// Generated by CoffeeScript 1.3.3

_.extend(Template.achievements, {
  events: {
    'click .btn': function(e) {
      var filter;
      filter = $(e.currentTarget).data('filter');
      return Session.toggle("btn-" + filter, true);
    }
  },
  achievements: function() {
    var sel, sort;
    sort = Template.filter.sort();
    sel = Template.filter.select();
    sel.$where = function() {
      var a, f;
      a = Accomplishments.findOne({
        user: Meteor.user()._id,
        entity: this._id
      });
      f = Favourites.findOne({
        user: Meteor.user()._id,
        entity: this._id,
        active: true
      });
      if (!Session.get('btn-completed') && !Session.get('btn-accepted')) {
        return !a && !f;
      } else if (!Session.get('btn-completed')) {
        return !a;
      } else if (!Session.get('btn-accepted')) {
        return !f;
      } else {
        return true;
      }
    };
    return Achievements.find(sel, {
      sort: sort
    });
  }
});