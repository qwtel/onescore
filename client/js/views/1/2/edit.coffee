_.extend Template.edit, Template.vote,
  events:
    'click .close': (e) ->
      Session.set 'styleGuide', true

    'click .discard': (e) ->
      Session.toggle 'expand', @_id

    'click .suggest': (e) ->
      title = $("#title-#{@_id}").val()

      data =
        title: title
        type: 'title'
        entity: @_id
        user: Meteor.user()._id
        score: 0

      id = Titles.insert data

      _.extend data, _id: id

      Meteor.call 'assignBestTitle', data

    'change .category': (e) ->
      @category = $("#category-#{@_id}").val()
      Session.toggle 'redraw'

    'change .description': (e) ->
      @description = $("#description-#{@_id}").val()
      @tags = _.union @tags, window.findTags(@description)
      Session.toggle 'redraw'
    
    'click .create': (e) ->
      data = {}
      
      $("#form-#{@_id}").find('.lazy').each ->
        $t = $(this)
        field = $t.data('field')
        if field?
          data[field] = $t.val()

      data.tags = @tags
      data.created = true

      Achievements.update @_id,
        $set:
          data

      Session.set 'newAchievement', null

  selected: (category) ->
    if category
      return if category is @name then 'selected' else ''
    else if Session.get('category')?
      return if Session.get('category') is @name then 'selected' else ''
    else
      return if 'Random' is @name then 'selected' else ''

  titles: ->
    id = Session.get 'single'
    titles = Titles.find
      entity: id
      user: Meteor.user()._id
    ,
      sort:
        score: -1

    return titles
  
  # NOTE: Empty cursor gets not interpreted as "falsy" value by handlebars
  hasTitles: ->
    id = Session.get 'single'
    titles = Titles.find
      entity: id
      user: Meteor.user()._id
    return titles.count()

_.extend Template.edit.events, Template.vote.events
