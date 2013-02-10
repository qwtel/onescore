// Generated by CoffeeScript 1.3.3

_.extend(Template.miniTitles, {
  titles: function() {
    var test, titles;
    test = Titles.find({
      entity: this._id,
      user: Meteor.user()._id
    });
    titles = Titles.find({
      entity: this._id,
      user: Meteor.user()._id
    }, {
      sort: {
        score: -1
      },
      limit: 5
    });
    if (test.count() === 0) {
      return false;
    } else {
      return titles;
    }
  }
});
