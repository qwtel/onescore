// Generated by CoffeeScript 1.3.3
var calculateScore, countVotes, hotScore, naiveScore, notify, patch, updateScore, wilsonScore;

patch = function(entity, diff, keys) {
  _.each(keys, function(key) {
    if (_.isArray(entity[key])) {
      if (diff[key].removed) {
        entity[key] = _.union(entity[key], diff[key].removed);
      }
      if (diff[key].added) {
        return entity[key] = _.difference(entity[key], diff[key].added);
      }
    } else if (_.isObject(entity[key])) {
      throw new Error("" + key + " is an Object, should recurse, but not implemented");
    } else if (diff[key]) {
      return entity[key] = diff[key];
    }
  });
  return entity;
};

Meteor.methods({
  restore: function(targetState) {
    var entity, revisions;
    entity = Collections[targetState.entityType].findOne(targetState.entity);
    entity.lastModifiedBy = this.userId;
    notify(targetState, entity);
    revisions = Revisions.find({
      entity: targetState.entity,
      date: {
        $gte: targetState.date
      }
    }, {
      sort: {
        date: -1
      }
    });
    revisions = revisions.fetch();
    _.each(revisions, function(revision) {
      var diff, keys;
      diff = revision.diff;
      keys = _.keys(diff);
      return entity = patch(entity, diff, keys);
    });
    delete entity._id;
    return Collections[targetState.entityType].update(targetState.entity, {
      $set: entity
    });
  },
  assignBestTitle: function(title) {
    var achievementId, best;
    achievementId = title.entity;
    best = Titles.findOne({
      entity: achievementId
    }, {
      sort: {
        score: -1
      }
    });
    if (best) {
      return Achievements.update(achievementId, {
        $set: {
          title: best.title
        }
      });
    }
  },
  basic: function() {
    var data;
    return data = {
      user: this.userId,
      date: new Date().getTime(),
      score: 0,
      hot: 0,
      best: 0,
      value: 0,
      comments: 0
    };
  },
  favourite: function(data) {
    var fav;
    fav = Favourites.findOne({
      user: this.userId,
      entity: data.entity
    });
    if (fav) {
      return Favourites.update(fav._id, {
        $set: {
          active: !fav.active
        }
      });
    } else {
      return Favourites.insert({
        type: 'favourite',
        user: this.userId,
        entity: data.entity,
        active: true
      });
    }
  },
  suggestTitle: function(data) {
    var achievement, basic, id, title;
    basic = Meteor.call('basic');
    _.extend(data, basic, {
      type: 'title'
    });
    id = Titles.insert(data);
    title = Titles.findOne(id);
    achievement = Achievements.findOne(title.entity);
    notify(title, achievement);
    return Meteor.call('assignBestTitle', title);
  },
  comment: function(data) {
    var basic, comment, id, parent, target;
    comment = Comments.findOne(data._id);
    if (comment && comment.user === this.userId) {
      return Comments.update(data._id, {
        $set: {
          text: data.text
        }
      });
    } else {
      basic = Meteor.call('basic');
      _.extend(data, basic, {
        entity: data.topic,
        entityType: data.topicType
      });
      parent = Comments.findOne(data.parent);
      if (parent) {
        _.extend(data, {
          parent: parent._id,
          mention: parent.user,
          level: parent.level + 1
        });
      } else {
        _.extend(data, {
          parent: null,
          mention: null,
          level: 0
        });
      }
      data.type = 'comment';
      id = Comments.insert(data);
      comment = Comments.findOne(id);
      target = Collections[comment.topicType].findOne(comment.topic);
      notify(comment, target);
      if (comment.parent != null) {
        parent = Comments.findOne(comment.parent);
        notify(comment, parent);
      }
      return Collections[comment.topicType].update(comment.topic, {
        $inc: {
          comments: 1
        }
      });
    }
  },
  vote: function(data) {
    var basic, id, target, vote;
    basic = Meteor.call('basic');
    _.extend(data, basic);
    vote = Votes.findOne({
      user: this.userId,
      entity: data.entity
    });
    if (vote) {
      Votes.update(vote._id, {
        $set: data
      });
    } else {
      data.type = 'vote';
      id = Votes.insert(data);
      vote = Votes.findOne(id);
      target = Collections[vote.entityType].findOne(vote.entity);
      notify(vote, target);
    }
    return calculateScore(Collections[data.entityType], data.entity);
  },
  accomplish: function(data) {
    var acc, accomplishId, accomplishment, achievement, basic, tags;
    acc = Accomplishments.findOne({
      user: this.userId,
      entity: data.entity
    });
    if (acc) {
      acc.tags || (acc.tags = []);
      data.tags || (data.tags = []);
      tags = _.union(acc.tags, data.tags);
      Accomplishments.update(acc._id, {
        $set: {
          story: data.story,
          tags: tags
        }
      });
      accomplishId = acc._id;
    } else {
      basic = Meteor.call('basic');
      _.extend(data, basic);
      data.type = 'accomplishment';
      accomplishId = Accomplishments.insert(data);
      achievement = Achievements.findOne(data.entity);
      Meteor.users.update(this.userId, {
        $inc: {
          score: achievement.value
        }
      });
      accomplishment = Accomplishments.findOne(accomplishId);
      notify(accomplishment, achievement);
    }
    return accomplishId;
  },
  updateUserScoreComplete: function() {
    var a, s, score;
    if (!this.is_simulation) {
      a = Achievements.find({
        $where: "          return db.accomplishments.findOne({            user: '" + this.userId + "',            entity: this._id          }) "
      }, {
        fields: {
          value: 1
        }
      });
      a = a.fetch();
      s = _.pluck(a, 'value');
      score = _.reduce(s, function(memo, num) {
        return memo + num;
      }, 0);
      return Meteor.users.update(this.userId, {
        $set: {
          score: score
        }
      });
    }
  }
});

countVotes = function(id, up) {
  return Votes.find({
    entity: id,
    up: up
  }).count();
};

updateScore = function(collection, id, score) {
  return collection.update(id, {
    $set: {
      score: score.naive,
      best: score.wilson,
      hot: score.hot,
      value: Math.round(10 * score.wilson)
    }
  });
};

notify = function(entity, target) {
  var receivers;
  if (entity && target) {
    receivers = [target.user];
    return Notifications.insert({
      date: new Date().getTime(),
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

calculateScore = function(collection, id) {
  var doc, down, score, up;
  up = countVotes(id, true);
  down = countVotes(id, false);
  doc = collection.findOne(id);
  score = {
    naive: naiveScore(up, down),
    wilson: wilsonScore(up, up + down),
    hot: hotScore(up, down, doc.date)
  };
  return updateScore(collection, id, score);
};

naiveScore = function(up, down) {
  return up - down;
};

wilsonScore = function(pos, n) {
  var phat, z;
  if (n === 0) {
    return 0;
  }
  z = 1.96;
  phat = pos / n;
  return (phat + z * z / (2 * n) - z * Math.sqrt((phat * (1 - phat) + z * z / (4 * n)) / n)) / (1 + z * z / n);
};

hotScore = function(up, down, date) {
  var a, b, ts, x, y, z;
  a = new Date(date).getTime();
  b = new Date(2005, 12, 8, 7, 46, 43).getTime();
  ts = a - b;
  x = naiveScore(up, down);
  if (x > 0) {
    y = 1;
  } else if (x < 0) {
    y = -1;
  } else {
    y = 0;
  }
  z = Math.max(Math.abs(x), 1);
  return Math.round(Math.log(z) / Math.log(10) + y * ts / 45000);
};
