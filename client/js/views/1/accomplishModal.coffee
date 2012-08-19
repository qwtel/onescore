_.extend Template.accomplishModal,
  #events:
  #  'click *': (e) ->
  #    $('#modal').modal 'hide'
  #
  achievement: ->
    id = Session.get 'modal'
    if id
      Achievements.findOne id

  callback: ->
    Meteor.setTimeout =>
      $('#modal').modal()
        #backdrop: false
      $('#modal').on 'hidden', ->
        Session.set 'modal', null
    ,
      0
    return ''
