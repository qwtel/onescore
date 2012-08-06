// Generated by CoffeeScript 1.3.3
(function() {

  _.extend(Template.comments, {
    events: {
      'keyup .new-thread,  keydown .new-thread': window.makeOkCancelHandler({
        ok: function(text, e) {
          Comments.insert({
            text: text,
            date: new Date,
            topic: Session.get('single'),
            parent: null,
            mention: null,
            user: Meteor.user()._id,
            score: 0
          });
          Session.set('add-comment', null);
          Session.set('edit-comment', null);
          return e.target.value = "";
        }
      }),
      'keyup .comment-text, keydown .comment-text, \
     keyup .edit-text, keydown .edit-text': window.makeOkCancelHandler({
        ok: function(text, e) {
          if (Session.get('add-comment') !== null) {
            Comments.insert({
              text: text,
              date: new Date,
              topic: Session.get('single'),
              parent: Session.get('thread'),
              mention: this.user,
              user: Meteor.user()._id,
              score: 0
            });
          } else if (Session.equals('edit-comment', this._id)) {
            Comments.update(this._id, {
              $set: {
                text: text
              }
            });
          }
          Session.set('add-comment', null);
          Session.set('edit-comment', null);
          return e.target.value = "";
        }
      })
    },
    select: function(id) {
      var sel;
      sel = {
        topic: Session.get('single'),
        parent: null
      };
      if (id) {
        sel.parent = id;
      } else {
        if (Session.equals('comment-filter', 'my')) {
          sel.user = Session.get('user');
        }
      }
      return sel;
    },
    comments: function() {
      var data, sel, sort;
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
      sel = Template.comments.select();
      return Comments.find(sel, {
        sort: data
      });
    },
    replies: function() {
      var sel;
      sel = Template.comments.select(this._id);
      return Comments.find(sel, {
        sort: {
          date: 1
        }
      });
    },
    noContent: function() {
      var sel;
      console.log('tasdf<');
      if (Session.equals('commentsLoaded', true)) {
        sel = Template.comments.select();
        return Comments.find(sel).count() === 0;
      }
      return false;
    }
  });

}).call(this);
