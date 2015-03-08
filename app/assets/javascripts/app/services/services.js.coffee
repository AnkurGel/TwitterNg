FeedServices = angular.module('FeedServices', [])

FeedServices.factory 'Auth', ['$q', ($q) ->
  exports = {
    init: ->
      OAuth.initialize('B_OzMdtd15usKNwsT7wl30lIsUI', { cache: true })
    connect: (service) ->
      deferred = $q.defer()
      unless service.connected
        OAuth.popup(service.provider, { cache: true })
          .done -> service.connected = true; deferred.resolve()
          .fail -> service.connected = false; alert("Something went wrong while connecting with " + provider)
      else deferred.resolve()
      deferred.promise
  }
]

FeedServices.factory 'Twitter', ['$q', 'Auth', 'Defer', ($q, Auth, Defer) ->
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

    getUserInfo: -> Defer(twitterObject, '/1.1/account/verify_credentials.json')

    getTimeline: -> Defer(twitterObject, '/1.1/statuses/home_timeline.json')

    retweet: (tweet) ->
      deferred = $q.defer()
      unless tweet.retweeted
        twitterObject.post("/1.1/statuses/retweet/" + tweet.id_str + ".json")
          .done (data)-> deferred.resolve data
          .fail -> alert("Something went wrong while attempting to retweet this")
        deferred.promise
      else
        # Process to undo a retweet is shady as fuck.
        undoRetweet(tweet)

    favorite: (tweet) ->
      deferred = $q.defer()
      url = if tweet.favorited then "1.1/favorites/destroy.json" else "/1.1/favorites/create.json"
      twitterObject.post(url, data: {id: tweet.id_str} )
        .done (data)-> deferred.resolve data
        .fail -> alert("Something went wrong while favoriting this tweet")
      deferred.promise

    getUserTimeline: (userId) ->
      Defer(twitterObject, '/1.1/statuses/user_timeline.json', {userId: userId})

  }
  undoRetweet = (tweet) ->
    deferred = $q.defer()
    Defer(twitterObject, '/1.1/statuses/user_timeline.json?include_my_retweet=1')
    .then (data) ->
      result = data
      .filter (t) -> t.retweeted
      .filter (t) -> t.retweeted_status.id == tweet.id
      if result.length > 0
        twitterObject.post('/1.1/statuses/destroy/' + result[0].id_str + '.json')
        .done (data) -> deferred.resolve data
        .fail -> alert("Could not destroy the retweet")
      else
        alert("Could not find this tweet in your recent timeline")
        deferred.resolve
    deferred.promise
  exports
]

FeedServices.factory 'Defer', ['$q', ($q) ->
  (api, url, params) ->
    deferred = $q.defer()
    url = url + "?" + $.param(params) if params?
    api.get(url)
      .done (data) -> deferred.resolve data
      .fail -> alert("Failed while requesting " + url)
    deferred.promise

]
