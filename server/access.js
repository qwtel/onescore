// Generated by CoffeeScript 1.3.3
(function() {

  Meteor.startup(function() {
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
    /*
      Todos.allow
        insert: -> return true
        update: canModify
        remove: canModify
        fetch: ['privateTo']
    */

    Achievements.allow({
      insert: self,
      update: creator
    });
    Titles.allow({
      insert: self,
      update: creator
    });
    Votes.allow({
      insert: uniqueVote,
      update: creator
    });
    Favourites.allow({
      insert: uniqueFav,
      update: creator
    });
    Quests.allow({
      insert: uniqueQuest,
      update: creator
    });
    Accomplishments.allow({
      insert: uniqueAcc,
      update: creator
    });
    Comments.allow({
      insert: self,
      update: creator
    });
    return Meteor.users.allow({
      update: function() {
        return true;
      }
    });
  });

}).call(this);
