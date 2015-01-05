FeedServices = angular.module('FeedServices', [])

FeedServices.factory 'Auth', ['$q', ($q) ->
  exports = {
    init: ->
      OAuth.initialize('B_OzMdtd15usKNwsT7wl30lIsUI', { cache: true })
    connect: (service) ->
      deferred = $q.defer()
      unless service.connected
        OAuth.popup(service.provider, { cache: true })
          .done(-> service.connected = true; console.log "successcal"; deferred.resolve())
          .fail(-> service.connected = false; alert("Something went wrong while connecting with " + provider))
      else deferred.resolve()
      deferred.promise
  }
]

FeedServices.factory 'Twitter', ['$q', 'Auth', ($q, Auth) ->
  exports = {
    provider: 'twitter'
    connected: false
    init: ->
      @connected = typeof OAuth.create('twitter') == 'object' ? true : false

    connect: -> Auth.connect @
    isReady: -> @connected
    logOut: ->
      OAuth.clearCache('twitter'); @connected = false
  }
  return exports
]

