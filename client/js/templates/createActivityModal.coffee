_.extend Template.createActivityModal,
  events:
    'click .create-activity': (e) ->
      name = $('.activity-name').val()
      url = encodeURIComponent((name.toLowerCase()).replace(/// \s ///g, '-'))
      tags = window.findTags $('.description-short').val()

      _.each @tags, (x) ->
        unless _.contains tags, x
          tags.push x

      data =
        name: name
        short: $('.description-short').val()
        full: $('.description-full').val()
        user: Session.get 'user'
        tags: tags
        url: url

      if Session.get 'activity'
        Activities.update @_id, $set: data
      else
        data.score = 0
        Activities.insert data

      $('.create-modal').modal 'hide'
      $('.activity-name, .description-short, .description-full').clear()

  title: ->
    activityId = Session.get 'activity'
    if activityId
      return @name
    else
      return 'Create New Activity'

