FeedServices = angular.module('FeedServices', [])

FeedServices.factory 'Auth', ['$q', ($q) ->
  exports = {
    init: ->
      OAuth.initialize('B_OzMdtd15usKNwsT7wl30lIsUI', { cache: true })
    connect: (service) ->
      deferred = $q.defer()
      unless service.connected
        OAuth.popup(service.provider, { cache: true })
          .done(-> service.connected = true; deferred.resolve())
          .fail(-> service.connected = false; alert("Something went wrong while connecting with " + provider))
      else deferred.resolve()
      deferred.promise
  }
]

FeedServices.factory 'Twitter', ['$q', 'Auth', ($q, Auth) ->
  twitterObject = false
  exports = {
    provider: 'twitter'
    connected: false
    init: ->
      twitterObject = OAuth.create('twitter')
      @connected = typeof twitterObject == 'object' ? true : false

    connect: -> Auth.connect @
    logOut: ->
      OAuth.clearCache 'twitter'
      @connected = false

    getUserInfo: ->
      deferred = $q.defer()
      twitterObject.get('/1.1/account/verify_credentials.json')
        .done (data) -> deferred.resolve data
        .fail -> alert("Something went wrong while fetching your info. Please try again.")
      deferred.promise

  }
  return exports
]

FeedServices.factory 'Defer', ['$q', ($q) ->
  (asyncAction) ->
    deferred = $q.defer()
    asyncAction()
]
