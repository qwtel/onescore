// Generated by CoffeeScript 1.3.3
(function() {

  _.extend(Template.singleComment, Template.comment, {
    events: {
      'click .edit': function(e) {
        if (!e.isPropagationStopped()) {
          e.stopPropagation();
          Session.set('addComment', null);
          Session.toggle('editComment', this._id);
          Meteor.flush();
          return window.focusById("edit-" + this._id);
        }
      },
      'click .reply': function(e) {
        Session.set('addComment', 'new');
        Meteor.flush();
        return window.focusById("add-" + this._id);
      },
      'click .vote': function(e) {
        var $t, up;
        if (!e.isPropagationStopped()) {
          e.stopPropagation();
          $t = $(e.target).closest('.vote');
          up = $t.data('up');
          return Meteor.call('vote', 'comments', this._id, up);
        }
      },
      'click .remove': function(e) {
        if (!e.isPropagationStopped()) {
          e.stopPropagation();
          return Comments.remove(this._id);
        }
      },
      'keyup .edit-text, keydown .edit-text': window.makeOkCancelHandler({
        ok: function(text, e) {
          if (Session.equals('editComment', this._id)) {
            Comments.update(this._id, {
              $set: {
                text: text
              }
            });
          }
          Session.set('addComment', null);
          Session.set('editComment', null);
          return e.target.value = "";
        }
      })
    },
    topic: function() {
      var collection;
      switch (this.type) {
        case 'comments':
          collection = Comments;
          break;
        case 'accomplishments':
          collection = Accomplishments;
          break;
        case 'achievements':
          collection = Achievements;
      }
      if (collection) {
        return collection.findOne(this.topic);
      }
    },
    breadcrumbs: function() {
      var breadcrumbs, comment, parent;
      breadcrumbs = [];
      parent = Session.get('parent');
      if (parent) {
        comment = Comments.findOne(parent);
        if (comment) {
          while (comment.parent !== null) {
            comment = Comments.findOne(comment.parent);
            breadcrumbs.push({
              name: Meteor.users.findOne(comment.user).username,
              user: comment.user,
              url: "/comments/" + comment._id
            });
          }
          breadcrumbs.push({
            name: 'Topic',
            user: null,
            url: "/" + comment.type + "/" + comment.topic
          });
        }
      }
      return breadcrumbs.reverse();
    }
  });

}).call(this);
