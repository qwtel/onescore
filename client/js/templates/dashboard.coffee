#.extend Template.dashboard,
# events:
#   'click .add-comment': (e) ->
#     Session.set 'add-comment', 0
#     Session.set 'edit-comment', null
#
#   'click .btn-filter': (e) ->
#     filter = $(e.target).data 'filter'
#     if filter
#       if Session.get('comment-filter') is filter
#         Session.set 'comment-filter', null
#       else
#         Session.set 'comment-filter', filter
#
#   'keyup .comment-text,  keydown .comment-text':
#     window.makeOkCancelHandler
#       ok: (text, e) ->
#         Comments.insert
#           text: text
#           date: new Date
#           topic: Session.get 'expand'
#           parent: null
#           mention: null
#           user: Meteor.user()._id
#         Session.set 'add-comment', null
#         Session.set 'edit-comment', null
#         e.target.value = ""
#
# addComment: ->
#   return Session.equals 'add-comment', 0
#
