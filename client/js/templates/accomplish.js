// Generated by CoffeeScript 1.3.3
(function() {

  _.extend(Template.accomplish, {
    events: {
      'click .create': function(e) {
        var stry;
        stry = $("#editor-" + this._id).val();
        Session.set('expand', null);
        return Meteor.call('accomplish', this._id, stry);
      },
      'click .uncreate': function(e) {
        return Accomplishments.remove(this._id);
      },
      'click .text': function(e) {
        return Session.toggle('story', 'text');
      },
      'click .picture': function(e) {
        return Session.toggle('story', 'picture');
      },
      'click .link': function(e) {
        return Session.toggle('story', 'link');
      }
    },
    accomplishment: function() {
      return Accomplishments.findOne({
        user: Meteor.user()._id,
        entity: this._id
      });
    },
    story: function() {
      var acpl;
      acpl = Accomplishments.findOne({
        user: Meteor.user()._id,
        entity: this._id
      });
      if (acpl) {
        if (acpl.story) {
          return acpl.story;
        }
      }
      return '';
    }
  });

}).call(this);
