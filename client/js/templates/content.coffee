_.extend Template.content,
  page: (page) ->
    return Session.equals 'page', page
