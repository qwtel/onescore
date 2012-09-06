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
  titles: function() {
    var titles;
    titles = Titles.find({
      entity: this._id,
      user: Meteor.user()._id
    }, {
      sort: {
        score: -1
      }
    });
    if (titles.count() === 0) {
      return false;
    } else {
      return titles;
    }
  }
});
