// Generated by CoffeeScript 1.3.3

_.extend(Template.favourites, {
  favourites: function() {
    var sort, user, username;
    sort = Template.filter.sort();
    username = Session.get('username');
    if (username) {
      user = Meteor.users.findOne({
        username: username
      });
      if (user) {
        return Favourites.find({
          user: user._id,
          active: true,
          $where: function() {
            return !Accomplishments.findOne({
              user: user._id,
              entity: this.entity
            });
          }
        }, {
          sort: sort
        });
      }
    }
  },
  achievement: function() {
    return Achievements.findOne(this.entity);
  }
});