// Generated by CoffeeScript 1.3.3

_.extend(Template.userActivity, {
  verb: function() {
    var verb;
    switch (this.type) {
      case 'accomplishment':
        verb = 'accomplished';
        break;
      case 'comment':
        if (this.parent != null) {
          verb = 'replied';
        } else {
          verb = 'commented';
        }
    }
    return verb;
  }
});
