_.extend Template.editAchievement,
  events:
    'click .close': (e) ->
      Session.set 'styleGuide', false

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
      Achievements.update @_id,
        $set:
          category: $("#category-#{@_id}").val()

    'change .description': (e) ->
      description = $("#description-#{@_id}").val()
      tags = window.findTags description

      #_.each @tags, (x) ->
      #  unless _.contains tags, x
      #    tags.push x

      Achievements.update @_id,
        $set:
          description: description
          tags: tags

    'click .create': (e) ->
      Achievements.update @_id,
        $set:
          created: true

      id = createNewAchievement()
      Session.set 'newAchievement', id
      Session.set 'expand', null

      #data = {}
      #
      #$('#form-new').find('input, textarea, select').each ->
      #  $t = $(this)
      #  field = $t.data('field')
      #  if field?
      #    data[field] = $t.val()

  selected: (category) ->
    if category
      return if category is @name then 'selected' else ''
    else
      return if 'Random' is @name then 'selected' else ''

