_.extend Template.accomplishActivityModal,
  events:
    'click .save-activity': (e) ->
      data =
        user: Session.get 'user'
        activity: Session.get 'activity'
        text: $('.accomplish-text').val()
        handedIn: false

      draft = Drafts.findOne
        user: Session.get 'user'
        activity: Session.get 'activity'

      if draft?
        if data.text isnt ''
          Drafts.update draft._id, $set: data
        else
          Drafts.remove draft._id
      else
        Drafts.insert data

      $('.accomplish-modal').modal 'hide'

    'click .hand-in-activity': (e) ->
      draft = Drafts.findOne
        user: Session.get 'user'
        activity: Session.get 'activity'

      Drafts.update draft,
        $set:
          handedIn: true

      $('.accomplish-modal').modal 'hide'

  draft: ->
    draft = Drafts.findOne
      user: Session.get 'user'
      activity: Session.get 'activity'

    return draft or {}

