# This is an Android like implementation of l18n.
# Very word that appears somewhere in the app should be written in here.
# They can be retrieved via the global (?) strings(id) function or via the 
# strings helper in templates e.g. {{strings "title"}} will return "Onescore"
strings = (id) -> (Strings.findOne id).string
Strings = new Meteor.Collection null
Strings.insert _id: 'title', string: 'Onescore'

Strings.insert _id: 'oneseccooldown', string: '1 second cooldown'
Strings.insert _id: 'xseccooldown', string: 'seconds cooldown'

Strings.insert _id: 'home', string: 'Home'
Strings.insert _id: 'homeDesc', string: 'View success stories of other players'
Strings.insert _id: 'notifications', string: 'Notifications'
Strings.insert _id: 'notificationDesc', string: 'See how other users interact with your content'
Strings.insert _id: 'explore', string: 'Explore'
Strings.insert _id: 'exploreDesc', string: 'Allows you to find new Achievements'
Strings.insert _id: 'ladder', string: 'Ladder'
Strings.insert _id: 'ladderDesc', string: 'Compete with other players based on your score'
Strings.insert _id: 'profile', string: 'Wall'
Strings.insert _id: 'profileDesc', string: 'Check out recent activity'
Strings.insert _id: 'questlog', string: 'Quest Log'
Strings.insert _id: 'questlogDesc', string: 'Keept track of Achievements you want to unlock'
Strings.insert _id: 'newAchievement', string: 'Create'
Strings.insert _id: 'newAchievementDesc', string: 'Create a new Achievement'
Strings.insert _id: 'replyAchievement', string: 'Create Follow-Up'
Strings.insert _id: 'replyAchievementDesc', string: 'Create a follow-up Achievement'
Strings.insert _id: 'accept', string: 'Star'
Strings.insert _id: 'acceptDesc', string: 'Add a locked Achievement to your Quest Log'
Strings.insert _id: 'accomplish', string: 'Unlock'
Strings.insert _id: 'accomplishDesc', string: 'Gives you the ability to unlock Achievements'
Strings.insert _id: 'inspect', string: 'Inspect'
Strings.insert _id: 'inspectDesc', string: 'Inspect your current target to get more information about it'

Strings.insert _id: 'titleHelp', string: "Suggest a title"
Strings.insert _id: 'descriptionHelp', string: "What has to be done to unlock this Achievement?"

Strings.insert _id: 'xp', string: 'Score'

Strings.insert _id: 'best', string: "Best"
Strings.insert _id: 'new', string: "New"
Strings.insert _id: 'old', string: "Old"
Strings.insert _id: 'hot', string: "Hot"

Strings.insert _id: 'me', string: "Me"
Strings.insert _id: 'friends', string: "Friends"
Strings.insert _id: 'city', string: "City"
Strings.insert _id: 'all', string: "All"

Strings.insert _id: 'styleGuide', string: "Style Guide"
Strings.insert _id: 'styleGuideText', string: "Achievements should have the following properties:"
Strings.insert _id: 'atomic', string: "Atomic"
Strings.insert _id: 'atomicText', string: "Achievements should not be composed."
Strings.insert _id: 'universal', string: "Universal"
Strings.insert _id: 'universalText', string: "Achievements should be easy to agree on."
Strings.insert _id: 'unique', string: "Unique"
Strings.insert _id: 'uniqueText', string: "Check if the Achievement already exists!"

Strings.insert _id: 'navigate', string: "Navigate"

Strings.insert _id: 'loadMore', string: "Load More"
Strings.insert _id: 'createNew', string: "Create New Achievement"
Strings.insert _id: 'doneThat', string: "I've done that!"

Strings.insert _id: 'signOut', string: "Sign out"

Strings.insert _id: 'howAreYouFeeling', string: "Congratulations! Why don't you tell us how you accomplished this Achievement?"
Strings.insert _id: 'whatsOnYourMind', string: "Write a Comment on this"
Strings.insert _id: 'ok', string: "OK"
Strings.insert _id: 'cancel', string: "Cancel"

Strings.insert _id: 'user', string: "User"
Strings.insert _id: 'achievement', string: "Achievement"
Strings.insert _id: 'accomplishment', string: "Unlock"
Strings.insert _id: 'comment', string: "Comment"
Strings.insert _id: 'vote', string: "Vote"
Strings.insert _id: 'entity', string: "Entity"

Strings.insert _id: 'unlock', string: "unlock"

Strings.insert _id: 'people', string: "People"
Strings.insert _id: 'creator', string: "Creator"
Strings.insert _id: 'achievers', string: "Unlocks"
Strings.insert _id: 'comments', string: "Comments"
Strings.insert _id: 'voters', string: "Voters"
Strings.insert _id: 'questers', string: "Questers"

Strings.insert _id: 'achiever', string: "Unlocker"

Strings.insert _id: 'rank', string: "Rank"
Strings.insert _id: 'activity', string: "Activity"
