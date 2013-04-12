Template.onescore.helpers
  onescore: ->
    sum = 0
    cursor = Meteor.users.find {}
    cursor.forEach (user) ->
      sum += user.profile.xp
    sum
