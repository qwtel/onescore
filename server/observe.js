// Generated by CoffeeScript 1.3.3
(function() {
  var fetchUserInformation, nextLevel, notify;

  notify = function(entity, target) {
    var receivers;
    if (entity && target) {
      receivers = [target.user];
      if (entity.mention) {
        receivers.push(entity.mention);
      }
      return Notifications.insert({
        date: new Date(),
        type: 'notification',
        user: entity.user,
        entity: entity._id,
        entityType: entity.type,
        target: target._id,
        targetType: target.type,
        receivers: receivers
      });
    }
  };

  fetchUserInformation = function(user) {
    var options, url,
      _this = this;
    url = "https://graph.facebook.com/" + user.services.facebook.id;
    options = {
      params: {
        access_token: user.services.facebook.accessToken
      }
    };
    return Meteor.http.get(url, options, function(error, res) {
      return Meteor.users.update(user._id, {
        $set: {
          username: res.data.username,
          bio: res.data.bio,
          location: res.data.location.name
        }
      });
    });
  };

  nextLevel = function(level) {
    var next;
    next = 0;
    switch (level) {
      case 1:
        next = 10;
        break;
      case 2:
        next = 25;
        break;
      case 3:
        next = 125;
        break;
      case 4:
        next = 525;
        break;
      case 5:
        next = 1225;
    }
    return next;
  };

  Meteor.startup(function() {
    var users;
    users = Meteor.users.find({}, {
      sort: {
        score: -1
      }
    });
    users.observe({
      added: function(user, beforeIndex) {
        fetchUserInformation(user);
        return Meteor.users.update(user._id, {
          $set: {
            level: 1,
            score: 0,
            rank: beforeIndex + 1
          }
        });
      },
      changed: function(user) {
        var next;
        next = nextLevel(user.level);
        if (user.score > next) {
          return Meteor.users.update(user._id, {
            $inc: {
              level: 1
            }
          });
        }
      },
      moved: function(user, oldRank, newRank) {
        return Meteor.users.update(user._id, {
          $set: {
            rank: newRank
          }
        });
      }
    });
    Titles.find().observe({
      changed: function(title) {
        return Meteor.call('assignBestTitle', title);
      },
      added: function(title) {
        var achievement;
        achievement = Achievements.findOne(title.entity);
        return notify(title, achievement);
      }
    });
    Accomplishments.find().observe({
      added: function(accomplishment) {
        var achievement;
        achievement = Achievements.findOne(accomplishment.entity);
        return notify(accomplishment, achievement);
      }
    });
    Votes.find().observe({
      added: function(vote) {
        var target;
        target = Collections[vote.entityType].findOne(vote.entity);
        return notify(vote, target);
      }
    });
    return Comments.find().observe({
      added: function(comment) {
        var target;
        target = Collections[comment.topicType].findOne(comment.topic);
        return notify(comment, target);
      }
    });
  });

}).call(this);
