// Generated by CoffeeScript 1.3.3
(function() {
  var creator, self, unique, uniqueAcc, uniqueFav, uniqueQuest, uniqueVote;

  creator = function(userId, entities) {
    return _.all(entities, function(entity) {
      return !entity.user || entity.user === userId;
    });
  };

  self = function(userId, doc) {
    return userId === doc.user;
  };

  unique = function(Collection, userId, doc) {
    var duplicate;
    if (self(userId, doc)) {
      duplicate = Collection.findOne({
        entity: doc.entity,
        user: doc.user
      });
      if (!duplicate) {
        return true;
      }
    }
    return false;
  };

  uniqueVote = function(userId, doc) {
    return unique(Votes, userId, doc);
  };

  uniqueFav = function(userId, doc) {
    return unique(Favourites, userId, doc);
  };

  uniqueQuest = function(userId, doc) {
    return unique(Quests, userId, doc);
  };

  uniqueAcc = function(userId, doc) {
    return unique(Accomplishments, userId, doc);
  };

  Meteor.startup(function() {
    /*
      Todos.allow
        insert: -> return true
        update: canModify
        remove: canModify
        fetch: ['privateTo']
    */
    Notifications.allow({
      insert: function() {
        return true;
      },
      update: function() {
        return true;
      },
      remove: function() {
        return true;
      }
    });
    Achievements.allow({
      insert: self,
      update: creator
    });
    Titles.allow({
      insert: self
    });
    Favourites.allow({
      insert: uniqueFav,
      update: creator
    });
    return Accomplishments.allow({
      insert: uniqueAcc,
      update: function() {
        return true;
      },
      remove: self
    });
  });

}).call(this);
