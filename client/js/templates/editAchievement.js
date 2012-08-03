// Generated by CoffeeScript 1.3.3
(function() {

  _.extend(Template.editAchievement, {
    events: {
      'click .close': function(e) {
        return Session.set('styleGuide', false);
      },
      'click .discard': function(e) {
        return Session.toggle('expand', this._id);
      },
      'click .suggest': function(e) {
        var title;
        title = $("#title-" + this._id).val();
        return Titles.insert({
          entity: this._id,
          title: title,
          user: Meteor.user()._id,
          score: 0
        });
      },
      'click .create': function(e) {
        var data, id;
        data = {};
        $("#form-" + this._id).find('.lazy').each(function() {
          var $t, field;
          $t = $(this);
          field = $t.data('field');
          if (field != null) {
            return data[field] = $t.val();
          }
        });
        data.created = true;
        Achievements.update(this._id, {
          $set: data
        });
        id = window.createNewAchievement();
        Session.set('newAchievement', id);
        return Session.set('expand', null);
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
    }
  });

}).call(this);
