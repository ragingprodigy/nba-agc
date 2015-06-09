
angular.module 'nbaAGC', [ 'ngResource', 'ngMessages', 'ui.router', 'mgcrea.ngStrap' ]

.config ['$stateProvider', '$urlRouterProvider', '$locationProvider', ( $stateProvider, $urlRouterProvider, $locationProvider )->
  $locationProvider.html5Mode true

  $urlRouterProvider.otherwise("/home")

  $stateProvider
  .state 'home',
    url: '/'
    templateUrl: 'views/index.html'
  .state 'register',
    url: '/register'
    templateUrl: 'views/home.html'
  .state 'register.bar',
    url: '/bar'
    templateUrl: 'views/register.html'
    controller: 'BarController'
  .state 'register.others',
    url: '/others'
    templateUrl: 'views/others.html'
    controller: 'OthersController'
  .state 'checkout',
    url: '/checkout'
    templateUrl: 'views/checkout.html'
    controller: 'CheckoutController'
  .state 'callback',
    url: '/callback'
    templateUrl: 'views/callback.html'
    controller: 'CallbackController'
]

.factory 'Api', ['$http', ($http)->
  mService =
    url: '/api'

    getAmountDue: (data) ->
      $http.post this.url + "/amountDue", data
      .then (r) ->
        r.data

  mService
]

.factory 'Session', ['$window', ($window) ->
  prefix = "___NBA_AGC___"
  {
  get: (key) ->
    $window.sessionStorage.getItem "#{prefix}#{key}"

  set: (key, value) ->
    $window.sessionStorage.setItem "#{prefix}#{key}", value

  clear: (key) ->
    $window.sessionStorage.removeItem "#{prefix}#{key}"
  }
]

.controller 'NavbarCtrl', ['$scope', '$location', ($scope, $location)->

  $scope.showBack = ->
    $location.path() isnt '/'
]

.controller 'BarController', [ '$scope', '$alert', 'Session', '$location', ( $scope, $alert, Session, $location )->

  $scope.years = [ 2014..1960 ]

  alert "Initd"

  $scope.d = {}

  $scope.checkout = ->
    if $scope.d.name_changed and not $scope.d.newname?.length
      $alert
        title: 'Error!'
        content: 'Please enter your current name (after it was changed)'
        placement: 'top-right'
        type: 'danger'
        duration: 5
    else
      if confirm "Are you sure?"
        # Save data in Session and Redirect to Checkout
        Session.set "registrantData", JSON.stringify $scope.d
        $location.path '/checkout'
]

.controller 'OthersController', [ '$scope', '$alert', 'Session', '$location', ( $scope, $alert, Session, $location ) ->

  $scope.years = [ 2014..1960 ]

  $scope.d = {}

  $scope.checkout = ->
    if $scope.d.name_changed and not $scope.d.newname?.length
      $alert
        title: 'Error!'
        content: 'Please enter your current name (after it was changed)'
        placement: 'top-right'
        type: 'danger'
        duration: 5
    else
      if confirm "Are you sure?"
        # Save data in Session and Redirect to Checkout
        Session.set "registrantData", JSON.stringify $scope.d
        $location.path '/checkout'

]

.controller 'CheckoutController', [ '$scope', 'Api', 'Session', '$window', ( $scope, Api, Session, $window ) ->

  $scope.data = JSON.parse Session.get('registrantData')

  # Ask Server to Calculate Amount to be paid
  Api.getAmountDue $scope.data
  .then (d) ->
    $scope.txn = d

  $scope.callbackUrl = ->
    "#{$window.location.origin}/callback"
]

String.prototype.hexEncode = ->
  result = ""
  for i in [0..this.length-1]
    hex = this.charCodeAt(i).toString(16)
    result += ("000"+hex).slice(-4)

  result


String.prototype.hexDecode = ->
  hexes = this.match(/.{1,4}/g) || []
  back = ""
  for j in [0..hexes.length-1]
    back += String.fromCharCode(parseInt(hexes[j], 16))

  back

Array.prototype.repeat = (what, L) ->
  while(L)
    this[--L] = what
  this