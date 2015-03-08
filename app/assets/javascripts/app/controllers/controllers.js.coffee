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

      Twitter.getTimeline().then (data) ->
        $(".row.tweets")
          .find('.loading').remove().end()
          .find('.content').removeClass('hide')
        $scope.newTweets.push.apply($scope.newTweets, data)
        console.log data
      Twitter.getUserTimeline().then (data) ->
        console.log(data)

  $scope.login = ->
    Twitter.connect().then ->
      $scope.isConnected = true
      Twitter.init()
      postSignIn()

  $scope.retweet = (tweet) ->
    Twitter.retweet(tweet).then ->
      tweet.retweeted = true

  $scope.favorite = (tweet) ->
    Twitter.favorite(tweet).then ->
      tweet.favorited = !tweet.favorited


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
