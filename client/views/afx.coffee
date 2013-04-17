Template.afx.helpers
  targetAchievement: ->
    page = Session.get 'page'
    temp = Session.get "#{page}/afx"
    if temp? then Achievements.findOne temp

  targetUser: ->
    page = Session.get 'page'
    temp = Session.get "#{page}/afx"
    if temp? then Meteor.users.findOne temp

  targetAccomplishment: ->
    page = Session.get 'page'
    temp = Session.get "#{page}/afx"
    if temp? then Accomplishments.findOne temp

  targetComment: ->
    page = Session.get 'page'
    temp = Session.get "#{page}/afx"
    if temp? then Comments.findOne temp

