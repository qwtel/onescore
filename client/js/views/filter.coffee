_.extend Template.filter,
  events:
    'change .sort': (e) ->
      $t = $(e.target).closest '.sort'
      Session.set 'sort', $t.find(':selected').val()

    'click .tab': (e) ->
      $t = $(e.target).closest '.tab'
      Session.set 'limit', $t.data 'tab'
