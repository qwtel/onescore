Template.breadcrumbs.helpers
  breadcrumbs: ->
    breadcrumbs = []
    id = Session.get 'id'
    if id
      parent = Achievements.findOne id
      if parent
        userId = Meteor.userId()
        if userId
          while parent.parent?
            parent = Achievements.findOne parent.parent

            color = 'uncompleted'
            if isActiveInCollection Accomplishments, parent._id, userId
              color = 'completed'
            else if isActiveInCollection Favourites, parent._id, userId
              color = 'accepted'

            breadcrumbs.push
              name: parent.title or '<No title>'
              color: color
              url: "/achievement/#{parent._id}"
              title: parent.description

          return breadcrumbs.reverse()
