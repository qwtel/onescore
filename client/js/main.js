// Generated by CoffeeScript 1.3.3
var AppRouter,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Session.set('limit', 'all');

AppRouter = (function(_super) {

  __extends(AppRouter, _super);

  function AppRouter() {
    return AppRouter.__super__.constructor.apply(this, arguments);
  }

  AppRouter.prototype.routes = {
    '': 'default',
    'home': 'home',
    'explore': 'explore',
    'ladder': 'ladder',
    'notifications': 'notifications',
    'achievements/new': 'newAchievement',
    'achievements/:id': 'achievements',
    'achievements/:id/:tab': 'achievements',
    'achievements/:id/:tab/:type': 'achievements',
    'achievement/:id': 'achievements',
    'achievement/:id/:tab': 'achievements',
    'achievement/:id/:tab/:type': 'achievements',
    'accomplishments/:id': 'accomplishments',
    'accomplishments/:id/:tab': 'accomplishments',
    'accomplishment/:id': 'accomplishments',
    'accomplishment/:id/:tab': 'accomplishments',
    'comments/:id': 'comments',
    'comments/:id/:something': 'comments',
    'comment/:id': 'comments',
    'comment/:id/:something': 'comments',
    'titles/:id': 'home',
    'votes/:id': 'home',
    ':user': 'user',
    ':user/:menu': 'user'
  };

  AppRouter.prototype["default"] = function() {
    return this.navigate('home', true);
  };

  AppRouter.prototype.home = function() {
    this.hardReset();
    Session.set('page', 'home');
    Session.set('sort', 'hot');
    return Session.set('type', 'accomplishment');
  };

  AppRouter.prototype.explore = function() {
    this.hardReset();
    Session.set('page', 'explore');
    Session.set('sort', 'best');
    return Session.set('type', 'achievement');
  };

  AppRouter.prototype.ladder = function() {
    this.hardReset();
    Session.set('page', 'ladder');
    return Session.set('sort', 'best');
  };

  AppRouter.prototype.notifications = function() {
    this.hardReset();
    Session.set('page', 'notifications');
    return Session.set('sort', 'new');
  };

  AppRouter.prototype.user = function(user, menu) {
    this.hardReset();
    Session.set('page', 'profile');
    Session.set('sort', 'new');
    Session.set('username', user);
    if (!menu) {
      menu = 'activity';
    }
    Session.set('menu', menu);
    if (menu === 'questlog') {
      return Session.set('type', 'achievement');
    } else {
      return Session.set('type', 'accomplishment');
    }
  };

  AppRouter.prototype.newAchievement = function() {
    this.softReset();
    Session.set('page', 'newAchievement');
    return Session.set('single', 'result');
  };

  AppRouter.prototype.achievements = function(id, tab, tabtab) {
    this.softReset();
    Session.set('page', 'achievements');
    Session.set('single', id);
    if (!tab) {
      tab = 'info';
    }
    Session.set('tab', tab);
    switch (tab) {
      case 'accomplish':
        if (!tabtab) {
          tabtab = null;
        }
        return Session.set('story', tabtab);
      case 'edit':
        if (!tabtab) {
          tabtab = 'basic';
        }
        return Session.set('tabtab', tabtab);
    }
  };

  AppRouter.prototype.accomplishments = function(id, tab) {
    this.softReset();
    Session.set('page', 'accomplishments');
    Session.set('single', id);
    if (!tab) {
      tab = 'info';
    }
    return Session.set('tab', tab);
  };

  AppRouter.prototype.comments = function(id, something) {
    this.softReset();
    Session.set('page', 'comments');
    Session.set('sort', 'best');
    return Session.set('single', id);
  };

  AppRouter.prototype.softReset = function() {
    $(document).scrollTop(0);
    Session.set('tagFilter', null);
    Session.set('menu', null);
    Session.set('newAchievement', null);
    Session.set('expand', null);
    Session.set('story', null);
    Session.set('parent', null);
    return Session.set('level', 0);
  };

  AppRouter.prototype.hardReset = function() {
    this.softReset();
    Session.set('single', null);
    Session.set('tab', null);
    Session.set('unexpand', null);
    return Session.set('skip', 0);
  };

  return AppRouter;

})(Backbone.Router);

window.Router = new AppRouter;

Meteor.startup(function() {
  return Backbone.history.start({
    pushState: true
  });
});
