// Generated by CoffeeScript 1.3.3

_.extend(Template.edit, {
  events: {
    'click .discard': function(e) {
      return Session.toggle('expand', this._id);
    },
    'click .suggest': function(e) {
      var data, title;
      title = $("#title-" + this._id).val();
      data = {
        title: title,
        entity: this._id
      };
      return Meteor.call('suggestTitle', data);
    },
    'change .description': function(e) {
      this.description = $("#description-" + this._id).val();
      if (!this.tags) {
        this.tags = [];
      }
      this.tags = _.union(this.tags, window.findTags(this.description));
      return Session.toggle('redraw');
    },
    'click .create': function(e) {
      var data;
      data = {};
      $("#form-" + this._id).find('.lazy').each(function() {
        var $t, field;
        $t = $(this);
        field = $t.data('field');
        if (field != null) {
          return data[field] = $t.val();
        }
      });
      if (!this.tags) {
        this.tags = [];
      }
      data.tags = this.tags;
      data.lastModifiedBy = Meteor.user()._id;
      Achievements.update(this._id, {
        $set: data
      });
      return window.Router.navigate("achievements/" + this._id, true);
    }
  },
  selected: function(category) {
    if (category) {
      if (category === this.name) {
        return 'selected';
      } else {
        return '';
      }
    } else if (Session.get('category') != null) {
      if (Session.get('category') === this.name) {
        return 'selected';
      } else {
        return '';
      }
    } else {
      if ('Random' === this.name) {
        return 'selected';
      } else {
        return '';
      }
    }
  },
  items: function() {
    return [
      {
        name: 'Basic',
        url: "/achievements/" + this._id + "/edit/basic",
        active: window.isActive('tabtab', 'basic')
      }, {
        name: 'Title',
        url: "/achievements/" + this._id + "/edit/title",
        active: window.isActive('tabtab', 'title')
      }, {
        name: 'Image',
        url: "/achievements/" + this._id + "/edit/image",
        active: window.isActive('tabtab', 'image')
      }, {
        name: 'Items',
        url: "/achievements/" + this._id + "/edit/items",
        active: window.isActive('tabtab', 'items')
      }, {
        name: 'Revisions',
        url: "/achievements/" + this._id + "/edit/revisions",
        active: window.isActive('tabtab', 'revisions')
      }
    ];
  },
  revisions: function() {
    return Revisions.find({
      entity: this._id
    }, {
      sort: {
        date: -1
      }
    });
  }
});
