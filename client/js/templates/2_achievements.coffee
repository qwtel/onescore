_.extend Template.achievements,
  events:
    'click .btn': (e) ->
      filter = $(e.currentTarget).data 'filter'
      Session.toggle "btn-#{filter}", true

  achievements: ->
    sort = Template.filter.sort()
    sel = Template.filter.select()

    sel.$where = ->
      a = Accomplishments.findOne
        user: Meteor.user()._id
        entity: @_id
    
      f = Favourites.findOne
        user: Meteor.user()._id
        entity: @_id
        active: true
    
      if not Session.get('btn-completed') and not Session.get('btn-accepted')
        return not a and not f
      else if not Session.get('btn-completed')
        return not a
      else if not Session.get('btn-accepted')
        return not f
      else
        return true

    Achievements.find sel, 
      sort: sort
      limit: 15*(Session.get('skip')+1)

