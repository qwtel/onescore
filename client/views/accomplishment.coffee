Template.accomplishment.events

Template.accomplishment.helpers
  user: -> Meteor.users.findOne()
  achievement: -> Achievements.findOne()
  story: -> Accomplishments.findOne()
