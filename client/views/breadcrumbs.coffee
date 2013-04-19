Template.breadcrumbs.helpers
  breadcrumbs: ->
    if Meteor.userId()?
      breadcrumbs = []
      parent = this
      while parent.entity? and parent.entityType?
        parent = Collections[parent.entityType].findOne parent.entity

        if parent.type is 'achievement'
          breadcrumbs.push
            _id: parent._id
            type: parent.type
            user: parent.user
            name: parent.title or strings 'noTitle'
            url: "/#{parent.type}/#{parent._id}"
            title: parent.description or strings 'noDesc'

        else if parent.type is 'accomplishment'
          user = Meteor.users.findOne parent.user
          breadcrumbs.push
            _id: parent._id
            type: parent.type
            user: parent.user
            name: user.profile.username or strings 'noTitle'
            url: "/#{parent.type}/#{parent._id}"
            title: parent.story or strings 'noDesc' 

        else
          user = Meteor.users.findOne parent.user
          breadcrumbs.push
            _id: parent._id
            type: parent.type
            user: parent.user
            name: user.profile.username or strings 'noTitle'
            url: "/#{parent.type}/#{parent._id}"
            title: parent.text or strings 'noDesc'  

      return breadcrumbs.reverse()
