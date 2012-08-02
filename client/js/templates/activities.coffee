_.extend Template.activities,
  events:
    'click #create .open': (e) ->
      window.Router.navigate 'activities/new', true

    'click .btn-filter': (e) ->
      Session.set 'tagFilter', null
      filter = $(e.target).data 'filter'
      which = $(e.target).data 'which'
      if Session.get("activity-filter-#{which}") is filter
          Session.set "activity-filter-#{which}", null
      else
        Session.set "activity-filter-#{which}", filter

  activities: ->
    sel = Template.activities.select()

    if Session.get 'tagFilter'
      sel.tags = Session.get 'tagFilter'

    return Activities.find sel,
      sort:
        score: -1
        name: 1

  select: ->
    sel = {}

    if Session.equals 'activity-filter-1', 'my'
      sel.user = Session.get 'user'

    else if Session.equals 'activity-filter-1', 'lva'
      sel.user = $lt: 2000000

    if Session.equals 'activity-filter-2', 'fav'
      sel.likes = Session.get 'user'

    else if Session.equals 'activity-filter-2', 'voted'
      sel.votes = Session.get 'user'

    else if Session.equals 'activity-filter-2', 'saved'
      drafts = Drafts.find(
        user: Session.get 'user'
        handedIn: false
      ).map (draft) ->
        return draft.activity
      sel._id = $in: drafts

    else if Session.equals 'activity-filter-2', 'pending'
      drafts = Drafts.find(
        user: Session.get 'user'
        handedIn: true
      ).map (draft) ->
        return draft.activity
      sel._id = $in: drafts

    else if Session.equals 'activity-filter-2', 'done'
      sel = null

    return sel

  noContent: ->
    if Session.equals 'activitiesLoaded', true
      sel = Template.activities.select()
      return Activities.find(sel).count() is 0
    return false

