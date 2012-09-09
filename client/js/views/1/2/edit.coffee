_.extend Template.edit,
  events:
    'click .discard': (e) ->
      Session.toggle 'expand', @_id

    'click .suggest': (e) ->
      title = $("#title-#{@_id}").val()

      data =
        title: title
        entity: @_id

      Meteor.call 'suggestTitle', data

    #'change .category': (e) ->
    #  @category = $("#category-#{@_id}").val()
    #  #Session.toggle 'redraw'

    'change .description': (e) ->
      @description = $("#description-#{@_id}").val()

      unless @tags then @tags = []
      @tags = _.union @tags, window.findTags(@description)

      Session.toggle 'redraw'
    
    'click .create': (e) ->
      data = {}
      
      $("#form-#{@_id}").find('.lazy').each ->
        $t = $(this)
        field = $t.data('field')
        if field?
          data[field] = $t.val()

      unless @tags then @tags = []
      data.tags = @tags

      Achievements.update @_id, $set: data
      window.Router.navigate "achievements/#{@_id}", true

  selected: (category) ->
    if category
      return if category is @name then 'selected' else ''
    else if Session.get('category')?
      return if Session.get('category') is @name then 'selected' else ''
    else
      return if 'Random' is @name then 'selected' else ''

  items: ->
    [
        name: 'Basic'
        url: "/achievements/#{@_id}/edit/basic"
        active: window.isActive 'tabtab', 'basic'
      ,
        name: 'Title'
        url: "/achievements/#{@_id}/edit/title"
        active: window.isActive 'tabtab', 'title'
      ,
        name: 'Image'
        url: "/achievements/#{@_id}/edit/image"
        active: window.isActive 'tabtab', 'image'
      ,
        name: 'Items'
        url: "/achievements/#{@_id}/edit/items"
        active: window.isActive 'tabtab', 'items'
      ,
        name: 'Revisions'
        url: "/achievements/#{@_id}/edit/revisions"
        active: window.isActive 'tabtab', 'revisions'
    ] 

  revisions: ->
    Revisions.find
      entity: @_id
    ,
      sort:
        date: -1
