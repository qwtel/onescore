// Generated by CoffeeScript 1.3.3

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
    switch (Session.get('limit')) {
      case 'me':
        sel.user = Meteor.user()._id;
        break;
      case 'friends':
        sel.user = {
          $in: [Meteor.user()._id]
        };
    }
    return sel;
  },
  comments: function() {
    var comments, sel, sort;
    sel = Template.comments.select();
    sort = Template.filter.sort();
    comments = Comments.find(sel, {
      sort: sort
    });
    if (comments.count() === 0) {
      return false;
    }
    return comments;
  },
  user: function() {
    return Meteor.users.findOne(this.user);
  }
});