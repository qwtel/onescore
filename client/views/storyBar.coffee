Template.storyBar.events
  'click .click-me-im-famous': (e) ->
    e.stopImmediatePropagation()
    clickPill this, e

  'click .nav': (e) ->
    e.stopImmediatePropagation()

  'click .spell': (e) ->
    e.stopImmediatePropagation()
    $t = $(e.currentTarget).parents '.spells'
    id = $t.data 'id'
    if @click and @usable and @usable(id, 'accomplishment') then @click(id, 'accomplishment')


Template.storyBar.helpers
  skills: -> 
    user = Meteor.user()
    if user and user.profile
      Skills.find
        nav: $ne: true
        level: $lte: user.profile.level

  active: (id) ->
    if @active id then 'active' else ''

  votesDiff: ->
    @upVotes - (@votes - @upVotes)

  downVotes: ->
    (@votes - @upVotes)
