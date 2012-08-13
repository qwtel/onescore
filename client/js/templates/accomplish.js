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
      'click button.editor': function(e) {
        $('.editor').hide();
        return $('.preview').show();
      },
      'click button.preview': function(e) {
        $('.editor').show();
        return $('.preview').hide();
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
    },
    callback: function() {
      var _this = this;
      Meteor.setTimeout(function() {
        return $("#editor-" + _this._id).markdownEditor({
          toolbarLoc: $("#toolbar-" + _this._id),
          toolbar: "default",
          preview: $("#preview-" + _this._id)
        });
      }, 0);
      return '';
    }
  });

}).call(this);
