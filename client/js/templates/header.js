// Generated by CoffeeScript 1.3.3
(function() {

  _.extend(Template.header, {
    events: {
      'click .category .nav-item': function(e) {
        var $t, category;
        $t = $(e.target).closest('.category');
        category = $t.data('category');
        return Session.set('category', category);
      }
    },
    items: function() {
      var item, _i, _len, _ref;
      _ref = window.items;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        if (!item.url) {
          item.url = item.name.toLowerCase();
        }
      }
      return window.items;
    }
  });

}).call(this);
