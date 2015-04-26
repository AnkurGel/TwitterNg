FeedControllers = angular.module('FeedControllers', [])
FeedControllers.controller 'TwitterFeed', ['$scope', 'Auth', 'Twitter', ($scope, Auth, Twitter) ->
  Auth.init()
  Twitter.init()

  $scope.isConnected = Twitter.connected

  $scope.newTweets = []
  postSignIn = ->
    if $scope.isConnected
      $("#logout").slideDown 'slow'
      Twitter.getUserInfo().then (data) ->
        $scope.userInfo = data;
        $(".userInfo .loading").remove()
        $(".content").removeClass 'hide'

      prepareTimeline()

  prepareTimeline = (params) ->
    Twitter.getTimeline(params).then (data) ->
      console.log("Got")
      console.log data
      $(".row.tweets")
      .find('.loading').remove().end()
      .find('.content').removeClass('hide')
      present_tweets_id = $scope.newTweets.map (t) -> t.id
      data = data.filter (t, i) -> $.inArray(t.id, present_tweets_id) < 0
      $scope.newTweets.push.apply(data, $scope.newTweets)
      $scope.newTweets = data;
      console.log data
    Twitter.getUserTimeline().then (data) ->
      #console.log(data)

  $scope.login = ->
    Twitter.connect().then ->
      $scope.isConnected = true
      Twitter.init()
      postSignIn()

  $scope.retweet = (tweet) ->
    Twitter.retweet(tweet).then ->
      tweet.retweeted = !tweet.retweeted

  $scope.favorite = (tweet) ->
    Twitter.favorite(tweet).then ->
      tweet.favorited = !tweet.favorited

  $scope.refresh = -> prepareTimeline({ since_id: $scope.newTweets[0].id } if $scope.newTweets.length > 0)

  $scope.prefixLink = (suffix) ->
    ("http://twitter.com/" + $scope.userInfo.screen_name + "/" + suffix) if suffix? && $scope.userInfo?

  $scope.logout = ->
    jQuery("#logout").slideUp 'slow'
    Twitter.logOut()
    $scope.isConnected = false

  postSignIn()
  ]


FeedControllers.filter 'stripSrc', ->
  (input) -> input.replace('_normal', '') if input?
