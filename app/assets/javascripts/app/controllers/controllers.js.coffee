FeedControllers = angular.module('FeedControllers', [])
FeedControllers.controller 'TwitterFeed', ['$scope', 'Auth', 'Twitter', ($scope, Auth, Twitter) ->
  Auth.init()
  Twitter.init()

  $scope.login = ->
    Twitter.connect().then ->
      console.log("Connection to Twitter is successful")

  ]
