Template.comment.events
  'click .click-me-im-famous': (e) ->
    e.stopImmediatePropagation()
    clickPill this, e

  'click .nav': (e) ->
    e.stopImmediatePropagation()

  'click .spell': (e) ->
    e.stopImmediatePropagation()
    $t = $(e.currentTarget).parents('.spells')
    id = $t.data 'id'
    if @click and @usable and @usable(id, 'comment') then @click(id, 'comment')


Template.comment.helpers
  user: -> Meteor.users.findOne _id: @user

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
  
  hasBeenSelected: ->
    !Session.get "target-#{@_id}"

  successors: ->
    sel = Template.scope.getSelect()
    sel.entity = @_id
    query = Comments.find sel
    if query.count() is 0 then return false

    sort = Template.sort.getSort()
    limit = Session.get("limit-#{@_id}") or 1
    Comments.find sel,
      sort: sort
      #limit: 3 * limit
