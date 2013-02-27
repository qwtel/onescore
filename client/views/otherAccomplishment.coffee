Template.otherAccomplishment.helpers
  user: -> Meteor.users.findOne _id: @user
  achievement: -> Achievements.findOne _id: @entity
