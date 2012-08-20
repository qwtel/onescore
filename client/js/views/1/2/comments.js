// Generated by CoffeeScript 1.3.3
(function() {

  _.extend(Template.comments, {
    events: {
      'click .new': function(e) {
        Session.set('addComment', 'new');
        Meteor.flush();
        return window.focusById("add-" + this._id);
      },
      'keyup .new-thread,  keydown .new-thread': window.makeOkCancelHandler({
        ok: function(text, e) {
          var data;
          data = {
            text: text,
            parent: Session.get('parent'),
            topic: Session.get('topic'),
            topicType: Session.get('topicType')
          };
          Meteor.call('comment', data);
          Session.set('addComment', null);
          Session.set('editComment', null);
          return e.target.value = "";
        }
      })
    },
    select: function(id) {
      var sel;
      sel = {
        topic: Session.get('topic'),
        parent: Session.get('parent')
      };
      if (id) {
        sel.parent = id;
      }
      if (Session.equals('limit', 'me')) {
        sel.user = Meteor.user()._id;
      }
      if (Session.equals('limit', 'friends')) {
        sel.user = 'hugo';
      }
      return sel;
    },
    comments: function() {
      var sel, sort;
      sel = Template.comments.select();
      sort = Template.filter.sort();
      return Comments.find(sel, {
        sort: sort
      });
    },
    user: function() {
      return Meteor.users.findOne(this.user);
    }
  });

}).call(this);
