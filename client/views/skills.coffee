Template.skills.events
  'click .spell': (e) ->
    if @click and @usable and @usable() then @click()

Template.skills.helpers
  skills: ->
    user = Meteor.user()
    if user and user.profile
      Skills.find 
        nav: $ne: true
        level: $lte: user.profile.level

  cooldownText: ->
    if @cooldown?
      if @cooldown == 1
        return '1 second cooldown'
      else
        return "#{@cooldown} seconds cooldown"
    else
      return '' 
