_.extend Template.edit,
  events:
    'click .close': (e) ->
      Session.set 'styleGuide', true

    'click .discard': (e) ->
      Session.toggle 'expand', @_id

    'click .suggest': (e) ->
      title = $("#title-#{@_id}").val()

      Titles.insert
        entity: @_id
        title: title
        user: Meteor.user()._id
        score: 0

    'change .category': (e) ->
      @category = $("#category-#{@_id}").val()

    'change .description': (e) ->
      description = $("#description-#{@_id}").val()
      tags = window.findTags description
    
      @description = description
      @tags = tags

      ## HACK: force redraw
      #Session.set 'tab', 'info'
      #Session.set 'tab', 'edit'

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

      Achievements.update @_id,
        $set:
          data

      id = window.createNewAchievement()
      Session.set 'newAchievement', id
      Session.set 'expand', null

    'click .vote': (e) ->
      unless e.isPropagationStopped()
        $t = $(e.target)
        unless $t.hasClass 'vote' then $t = $t.parents '.vote'
        up = $t.data 'up'
        Meteor.call 'vote', 'titles', @_id, up
        e.stopPropagation()

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

  voted: (state) ->
    state = if state is "up" then true else false

    vote = Votes.findOne
      user: Meteor.user()._id
      entity: @_id
    if vote and vote.up is state
      return 'active'
    return ''
