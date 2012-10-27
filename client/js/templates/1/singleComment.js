// Generated by CoffeeScript 1.3.3

_.extend(Template.singleComment, Template.comment, {
  events: {
    'click .replyy': function(e) {
      Session.toggle('addComment', 'new');
      Meteor.flush();
      return window.focusById("add-" + this._id);
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
          url: "/" + comment.topicType + "/" + comment.topic + "/talk"
        });
      }
    }
    return breadcrumbs.reverse();
  }
});