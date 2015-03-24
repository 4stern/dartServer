angular.module('yn', [])
    .controller('statsController', ['$scope', '$http', function($scope,$http) {
        $http.get('/api/getData').
            success(function(data, status, headers, config) {
                console.log(data);
                $scope.data = data;
            })
    }])