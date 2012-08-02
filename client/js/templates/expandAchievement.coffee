_.extend Template.expandAchievement,
  events:
    'click .tab': (e) ->
      tab = $(e.target).data 'tab'
      Session.set 'expandTab', tab

