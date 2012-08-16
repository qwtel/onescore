// Generated by CoffeeScript 1.3.3
(function() {
  var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  window.items = [
    {
      name: 'Home'
    }, {
      name: 'Explore'
    }, {
      name: 'Ladder'
    }
  ];

  window.categories = [
    {
      name: 'Carrier'
    }, {
      name: 'Education'
    }, {
      name: 'Health'
    }, {
      name: 'Meta'
    }, {
      name: 'Random'
    }, {
      name: 'Sports'
    }
  ];

  window.makeOkCancelHandler = function(options) {
    var cancel, ok;
    ok = options.ok || function() {};
    cancel = options.cancel || function() {};
    return function(evt) {
      var value;
      if (evt.type === "keydown" && evt.which === 27) {
        return cancel.call(this, evt);
      } else if (evt.type === "keyup" && evt.which === 13) {
        value = String(evt.target.value || "");
        if (value) {
          return ok.call(this, value, evt);
        } else {
          return cancel.call(this, evt);
        }
      }
    };
  };

  window.focusById = function(id) {
    return $("#" + id).focus();
  };

  window.findTags = function(text) {
    var match, pattern, tags;
    pattern = /[^&]\B(#(\w\w+))/g;
    text = _.escape(text);
    tags = [];
    while (match = pattern.exec(text)) {
      tags.push(match[2]);
    }
    return tags;
  };

  window.wrapTags = function(text) {
    var pattern;
    if (text) {
      pattern = /[^&]\B(#(\w\w+))/g;
      text = _.escape(text);
      return text.replace(pattern, ' <a class="tag" data-tag="$2">$1</a>');
    }
    return '';
  };

  $.fn.clear = function() {
    return $(this).val('');
  };

  window.positionActivityModal = function($modal, id) {
    var p;
    if (id != null) {
      p = $('#activity-' + id).offset();
    }
    if (!(id != null) || !(p != null)) {
      p = {};
      p.top = 50;
    }
    $modal.modal({
      keyboard: false,
      show: true
    }).offset({
      top: p.top
    }).on('hide', function() {
      $('body').height('auto');
      return window.Router.navigate('activities', true);
    });
    $('body').height($('body').height() + $(window).height());
    return $(document).scrollTop(p.top - 50);
  };

  window.getUsername = function(userId) {
    var user;
    user = Ushers.findOne(userId);
    if (user) {
      return user.name;
    }
    return '';
  };

  Session.toggle = function(name, value) {
    if (value != null) {
      if (Session.equals(name, value)) {
        return Session.set(name, null);
      } else {
        return Session.set(name, value);
      }
    } else {
      return Session.set(name, !Session.get(name));
    }
  };

  Session.push = function(name, key, value) {
    var field;
    field = Session.get(name);
    if (!field) {
      field = {};
      Session.set(name, field);
    }
    if (field[key] === value) {
      field[key] = null;
    } else {
      field[key] = value;
    }
    return Session.toggle('redraw', true);
  };

  Handlebars.registerHelper('session', function(name) {
    return Session.get(name);
  });

  Handlebars.registerHelper('show', function(name) {
    return Session.equals(name, true);
  });

  Handlebars.registerHelper('equals', function(name, value) {
    return Session.equals(name, value);
  });

  Handlebars.registerHelper('isActive', function(name, value) {
    if (Session.equals(name, value)) {
      return 'active';
    } else {
      return '';
    }
  });

  Handlebars.registerHelper('belongsTo', function(user) {
    return Meteor.user()._id === user._id;
  });

  Handlebars.registerHelper('isMe', function(user) {
    if (user) {
      if (Meteor.user()._id === user._id) {
        return 'my';
      } else {
        return '';
      }
    }
  });

  Handlebars.registerHelper('userIn', function(field) {
    var _ref;
    if (field != null) {
      return _ref = Session.get('user'), __indexOf.call(field, _ref) >= 0;
    }
    return false;
  });

  Handlebars.registerHelper('activity', function() {
    var activity, activityId;
    activityId = Session.get('activity');
    activity = Activities.findOne(activityId);
    return activity || {};
  });

  Handlebars.registerHelper('wrapTags', window.wrapTags);

  Handlebars.registerHelper('getUsername', window.getUsername);

  Handlebars.registerHelper('categories', function() {
    var cat, _i, _len, _ref;
    _ref = window.categories;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      cat = _ref[_i];
      if (!cat.url) {
        cat.url = cat.name.toLowerCase();
      }
    }
    return window.categories;
  });

  Handlebars.registerHelper('formatDate', function(date) {
    var d;
    d = moment(new Date(date));
    return d.format("DD.MM.YYYY, hh:mm");
  });

  Handlebars.registerHelper('timeago', function(date) {
    var d;
    d = moment(new Date(date));
    return d.fromNow();
  });

}).call(this);
