_.extend Template.expand,
  events:
    'click .tab': (e) ->
      tab = $(e.target).data 'tab'
      Session.set 'tab', tab

      if e.which is 1
        e.preventDefault()
        href = $(e.target).attr 'href'
        if href then window.Router.navigate href, true

