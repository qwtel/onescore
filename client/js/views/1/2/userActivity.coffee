_.extend Template.userActivity,
  user: ->
    return Meteor.users.findOne @user
  
  verb: ->
    console.log this
    if @type is 'accomplishment' then verb = 'accomplished'
    if @type is 'comment'
      if @parent?
        verb = 'replied'
      else
        verb = 'commented'

    return verb

  #events:
  #  'click .edit': (e) ->
  #    value = Session.get 'editUsername'
  #    Session.set 'editUsername', !value
  #    Meteor.flush()
  #    $('#user-name').focus()
  #
  #  'keyup #user-name, keydown #user-name':
  #    window.makeOkCancelHandler
  #      ok: (text, e) ->
  #        text = text.replace /// \s ///g, ''
  #        Ushers.update @_id,
  #          name: text
  #        Session.set 'editUsername', false
  #
  #user: ->
  #  return Ushers.findOne Session.get('user')
  #
  #editUsername: ->
  #  return Session.equals 'editUsername', true

