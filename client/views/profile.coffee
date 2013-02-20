Template.profile.events

Template.profile.helpers
  user: ->
    id = Session.get 'id'
    Meteor.users.findOne id

  accomplishments: ->
    id = Session.get 'id'

    sel = Template.filter.getSelect()
    sel.user = id
    sel.active = true

    sort = Template.filter.getSort()
    Accomplishments.find sel,
      sort: sort
      limit: 5 * Session.get 'limit'

  achievement: ->
    Achievements.findOne @entity
