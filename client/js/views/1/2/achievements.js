// Generated by CoffeeScript 1.3.3
(function() {

  _.extend(Template.achievements, {
    select: function() {
      var sel;
      sel = {};
      sel.created = true;
      if (Session.get('category') != null) {
        sel.category = Session.get('category');
      }
      return sel;
    },
    achievements: function() {
      var a, sel, sort;
      sel = Template.achievements.select();
      sort = Template.filter.sort();
      a = Achievements.find(sel, {
        sort: sort
      });
      return a;
    }
  });

}).call(this);
