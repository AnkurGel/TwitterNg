FeedControllers = angular.module('FeedControllers', [])
FeedControllers.controller 'TwitterFeed', ['$scope', 'Auth', 'Twitter', ($scope, Auth, Twitter) ->
  Auth.init()
  Twitter.init()

  $scope.isConnected = Twitter.connected

  postSignIn = ->
    if $scope.isConnected
      $("#logout").slideDown 'slow'
      applyLoading()
      Twitter.getUserInfo().then (data) ->
        $scope.userInfo = data;
        $(".userInfo .loading").remove();
        $(".content").removeClass('hide')
        console.log(data)

  applyLoading =->
    $(".userInfo")

  $scope.login = ->
    Twitter.connect().then ->
      $scope.isConnected = true
      Twitter.init()
      postSignIn()

  $scope.prefixLink = (suffix) ->
    ("http://twitter.com/" + $scope.userInfo.screen_name + "/" + suffix) if suffix? && $scope.userInfo?

  $scope.logout = ->
    jQuery("#logout").slideUp 'slow'
    Twitter.logOut()
    $scope.isConnected = false

  postSignIn();
  ]


FeedControllers.filter 'stripSrc', ->
  (input) -> input.replace('_normal', '') if input?
