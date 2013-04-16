Template.user.events
  'click .pill': (e) ->
    e.stopImmediatePropagation()
    clickPill this, e

  'click .nav': (e) ->
    e.stopImmediatePropagation()

  'click .spell': (e) ->
    e.stopImmediatePropagation()
    $t = $(e.currentTarget).parents '.spells'
    id = $t.data 'id'
    if @click and @usable and @usable(id, 'achievement') then @click(id, 'achievement')

Template.user.helpers
  skills: -> 
    user = Meteor.user()
    if user and user.profile
      Skills.find
        nav: $ne: true
        level: $lte: user.profile.level

  active: (id) ->
    if @active id then 'active' else ''

  credibility: ->
    Math.round 100 * @best
