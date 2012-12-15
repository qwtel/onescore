// Generated by CoffeeScript 1.3.3
var betaKeys, computeDifference, nextLevel, symetricDifference;

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

betaKeys = ["1237137766"];

Accounts.onCreateUser(function(options, user) {
  var query, res, url;
  if (options.profile) {
    user.profile = options.profile;
  }
  url = "https://graph.facebook.com/" + user.services.facebook.id;
  query = {
    params: {
      access_token: user.services.facebook.accessToken
    }
  };
  res = Meteor.http.get(url, query);
  if (!res || !res.data || !res.data.username) {
    throw new Error;
  }
  if (!_.contains(betaKeys, res.data.id)) {
    throw new Error;
  }
  _.extend(user, {
    type: 'user',
    date: new Date().getTime(),
    score: 0,
    hot: 0,
    best: 0,
    value: 0,
    comments: 0,
    username: res.data.username,
    level: 0,
    rank: 0,
    ranked: false
  });
  _.extend(user.profile, {
    username: res.data.username,
    bio: res.data.bio,
    location: res.data.location.name
  });
  return user;
});

Meteor.startup(function() {
  var users;
  users = Meteor.users.find({}, {
    sort: {
      score: -1
    }
  });
  users.observe({
    added: function(user, beforeIndex) {
      if (!user.ranked) {
        return Meteor.users.update(user._id, {
          $set: {
            ranked: true,
            level: 1,
            rank: beforeIndex + 1
          }
        });
      }
    },
    changed: function(user) {
      var next;
      next = nextLevel(user.level);
      if (user.score >= next) {
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
    }
  });
  Achievements.find().observe({
    changed: function(newDocument, atIndex, oldDocument) {
      var data, diff, keys;
      keys = ['description', 'category', 'tags'];
      diff = computeDifference(newDocument, oldDocument, keys);
      if (_.size(diff) > 0) {
        data = {
          type: 'revision',
          entity: newDocument._id,
          entityType: newDocument.type,
          date: new Date().getTime(),
          user: newDocument.lastModifiedBy,
          diff: diff
        };
        return Revisions.insert(data);
      }
    }
  });
  return Accomplishments.find().observe({
    changed: function(newDocument, atIndex, oldDocument) {
      var data, diff, keys;
      keys = ['story', 'tags'];
      diff = computeDifference(newDocument, oldDocument, keys);
      if (_.size(diff) > 0) {
        data = {
          type: 'revision',
          entity: newDocument._id,
          entityType: newDocument.type,
          date: new Date().getTime(),
          user: newDocument.lastModifiedBy,
          diff: diff
        };
      }
      return Revisions.insert(data);
    }
  });
});

symetricDifference = function(a, b) {
  var intersection, union;
  union = _.union(a, b);
  intersection = _.intersection(a, b);
  return _.difference(union, intersection);
};

computeDifference = function(newDocument, oldDocument, keys) {
  var diff;
  diff = {};
  _.each(keys, function(key) {
    var added, removed;
    if (_.isArray(newDocument[key])) {
      added = _.difference(newDocument[key], oldDocument[key]);
      removed = _.difference(oldDocument[key], newDocument[key]);
      if (_.size(added) > 0) {
        diff[key] || (diff[key] = {});
        diff[key]['added'] = added;
      }
      if (_.size(removed) > 0) {
        diff[key] || (diff[key] = {});
        return diff[key]['removed'] = removed;
      }
    } else if (_.isObject(newDocument[key])) {
      throw new Error("" + key + " is an Object, should recurse, but not implemented");
    } else if (newDocument[key] !== oldDocument[key]) {
      return diff[key] = oldDocument[key];
    }
  });
  return diff;
};
