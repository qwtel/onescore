// Generated by CoffeeScript 1.3.3

_.extend(Template.tagFilter, {
  events: {
    'click .tag': function(e) {
      return Session.push('tagFilter', this.tag);
    }
  },
  tags: function() {
    var collection, page, tagInfos;
    page = Session.get('page');
    if (Session.equals('menu', 'questlog')) {
      collection = Template.favourites.achievements();
    } else {
      collection = Collections[page];
      if (collection) {
        collection = collection.find();
      } else {
        return null;
      }
    }
    if (collection) {
      tagInfos = [];
      collection.forEach(function(entity) {
        return _.each(entity.tags, function(tag) {
          var tagInfo;
          tagInfo = _.find(tagInfos, function(x) {
            return x.tag === tag;
          });
          if (!tagInfo) {
            return tagInfos.push({
              tag: tag,
              count: 1
            });
          } else {
            return tagInfo.count++;
          }
        });
      });
      tagInfos = _.sortBy(tagInfos, function(x) {
        return -x.count;
      });
      return tagInfos;
    }
  }
});
