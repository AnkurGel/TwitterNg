FeedControllers = angular.module('FeedControllers', [])
FeedControllers.controller 'TwitterFeed', ['$scope', 'Auth', 'Twitter', ($scope, Auth, Twitter) ->
  Auth.init()
  Twitter.init()

  $scope.isConnected = Twitter.connected

  $scope.login = ->
    Twitter.connect().then ->
      $scope.isConnected = true

  ]
