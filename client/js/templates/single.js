// Generated by CoffeeScript 1.3.3
(function() {

  _.extend(Template.single, {
    achievement: function() {
      var id;
      id = Session.get('single');
      return Achievements.findOne(id);
    },
    accomplishment: function() {
      var id;
      id = Session.get('single');
      return Accomplishments.findOne(id);
    }
  });

}).call(this);