_.extend Template.edit, Template.vote,
  events:
    'click .close': (e) ->
      Session.set 'styleGuide', true

    'click .discard': (e) ->
      Session.toggle 'expand', @_id

    'click .suggest': (e) ->
      title = $("#title-#{@_id}").val()

      Titles.insert
        title: title
        type: 'title'
        entity: @_id
        user: Meteor.user()._id
        score: 0

    'change .category': (e) ->
      @category = $("#category-#{@_id}").val()

    'change .description': (e) ->
      description = $("#description-#{@_id}").val()
      tags = window.findTags description
    
      @description = description
      @tags = tags

      #_.each @tags, (x) ->
      #  unless _.contains tags, x
      #    tags.push x
    
      #Achievements.update @_id,
      #  $set:
      #    description: description
      #    tags: tags

    'click .create': (e) ->
      data = {}
      
      $("#form-#{@_id}").find('.lazy').each ->
        $t = $(this)
        field = $t.data('field')
        if field?
          data[field] = $t.val()

      data.created = true
      data.value = 0

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
