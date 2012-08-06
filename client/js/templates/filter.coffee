_.extend Template.filter,
  events:
    'change .sort': (e) ->
      $t = $(e.target).closest '.sort'
      Session.set 'sort', $t.find(':selected').val()
