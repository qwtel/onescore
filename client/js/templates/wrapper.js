// Generated by CoffeeScript 1.3.3
(function() {

  _.extend(Template.wrapper, {
    events: {
      'click a[href^="/"]': function(e) {
        var $t, href;
        if (e.which === 1 && !(e.ctrlKey || e.metaKey)) {
          e.preventDefault();
          $t = $(e.target).closest('a[href^="/"]');
          href = $t.attr('href');
          if (href) {
            return window.Router.navigate(href, true);
          }
        }
      }
    }
  });

}).call(this);