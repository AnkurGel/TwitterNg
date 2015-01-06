FeedControllers = angular.module('FeedControllers', [])
FeedControllers.controller 'TwitterFeed', ['$scope', 'Auth', 'Twitter', ($scope, Auth, Twitter) ->
  Auth.init()
  Twitter.init()

  $scope.isConnected = Twitter.connected

  $scope.login = ->
    Twitter.connect().then ->
      $scope.isConnected = true
      Twitter.init()
      $("#logout").slideDown 'slow'

  $scope.logout = ->
    jQuery("#logout").slideUp 'slow'
    Twitter.logOut()
    $scope.isConnected = false

  ]
