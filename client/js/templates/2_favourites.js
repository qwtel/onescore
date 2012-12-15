// Generated by CoffeeScript 1.3.3

_.extend(Template.favourites, {
  achievements: function() {
    var quests, sort, user, username;
    username = Session.get('username');
    if (username) {
      user = Meteor.users.findOne({
        username: username
      });
      if (user) {
        quests = Favourites.find({
          user: user._id,
          active: true,
          $where: function() {
            return !Accomplishments.findOne({
              user: user._id,
              entity: this.entity
            });
          }
        }, {
          fields: {
            entity: 1
          }
        });
        quests = quests.fetch();
        quests = _.pluck(quests, 'entity');
        if (_.size(quests) > 0) {
          sort = Template.filter.sort();
          return Achievements.find({
            _id: {
              $in: quests
            }
          }, {
            sort: sort
          });
        }
      }
    }
  }
});
