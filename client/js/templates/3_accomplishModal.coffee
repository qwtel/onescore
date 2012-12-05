_.extend Template.accomplishModal,
  #events:
  #  'click *': (e) ->
  #    $('#modal').modal 'hide'
  #

  achievement: ->
    id = Session.get 'modal'
    if id
      Achievements.findOne id

  rendered: ->
    id = Session.get 'modal'
    if id
      achievement = Achievements.findOne id
      if achievement
        $('#modal').modal()
          #backdrop: false
        $('#modal').on 'hidden', ->
          Session.set 'modal', null
