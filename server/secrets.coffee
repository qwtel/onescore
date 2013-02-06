#facebook = Accounts.loginServiceConfiguration.findOne
#  service: 'facebook'
#
#unless facebook
#  Accounts.loginServiceConfiguration.insert
#    service: 'facebook',
#    appId: '306419872769911',
#    secret: '76ad4f77e29289e2eb4f9ea8a267e248',
#    requestPermissions: [
#      "publish_stream"
#      "user_about_me"
#      "user_location"
#      "user_photos"
#      #"user_videos"
#    ]

# first, remove configuration entry in case service is already configured
#Accounts.loginServiceConfiguration.remove service: "facebook"
#Accounts.loginServiceConfiguration.remove({})
#console.log Accounts.loginServiceConfiguration.find().count()
