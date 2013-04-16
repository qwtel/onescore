Template.baseAchievement.events
  'click .achievement': (e) ->
    e.stopImmediatePropagation()
    clickPill this, e

  'click .nav': (e) ->
    e.stopImmediatePropagation()

  'click .spell': (e) ->
    e.stopImmediatePropagation()
    $t = $(e.currentTarget).parents '.spells'
    id = $t.data 'id'
    if @click and @usable and @usable(id, 'achievement') then @click(id, 'achievement')

  'click .yes': (e) ->
    Meteor.call 'deleteAchievement', @_id
    Session.set 'delete', null

  'click .no': (e) ->
    Session.set 'delete', null

#Template.baseAchievement.rendered = ->
#  # XXX: Does this create a memory leak?
#  $('.popover').remove()
#
#  $(@findAll('.spell')).popover
#    animation: false
#    container: 'body'
#    html: true
#    placement: 'bottom'
#    trigger: 'hover'

Template.baseAchievement.rendered = -> console.log 'rendered'
Template.baseAchievement.helpers
  skills: -> 
    user = Meteor.user()
    if user and user.profile
      Skills.find
        nav: $ne: true
        level: $lte: user.profile.level

  active: (id) ->
    if @active id then 'active' else ''

  title: ->
    if @title != '' then @title else strings('noTitle')
  
  description: ->
    if @description != '' then @description else strings('noDesc')
  
  votesDiff: ->
    @upVotes - (@votes - @upVotes)
  
  sub: (o1, o2) ->
    o1 - o2

  hasBeenSelected: ->
    Session.get "target-#{@_id}"

  badge: ->
    if @imgur?
      split = @imgur.link.split('.')
      fileExtension = split[split.length-1]
      return "http://i.imgur.com/#{@imgur.id}t.#{fileExtension}"
    else
      return '/img/bg_new.png'
