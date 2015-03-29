angular.module('yn', []).controller('statsController',
    ['$scope', '$http', function ($scope, $http) {

        $scope.currents={
            local: 'de',
            tag: 'german'
        };
        $scope.tags={};
        $scope.locals = [];
        $scope.users = {};

        reloadTags();

        $scope.switchTag=function(newTag){
            $scope.currents.tag = newTag;
            reloadUser();
        };
        $scope.switchLocal=function(newLocal){
            if($scope.locals.indexOf(newLocal)!=-1){
                $scope.currents.local = newLocal;
                reloadTags();
            }
        };

        function reloadTags(){
            var local = $scope.currents.local;
            $http.get('/api/getTags/'+local).success(function (data, status, headers, config) {
                console.log(data);
                var len = data.tags.length,
                    tmp = {};
                while(len--){
                    var tag = data.tags[len];
                    tmp[tag.name] = tag;
                }
                $scope.tags = tmp;
                for(var key in $scope.tags){
                    if($scope.tags.hasOwnProperty(key)){
                        $scope.switchTag($scope.tags[key].name);
                        break;
                    }
                }
            });
        }


        function reloadUser(){
            var local = $scope.currents.local,
                tag = $scope.currents.tag;
            $http.get('/api/users/'+local+'/'+tag).success(function (data, status, headers, config) {
                console.log(data);
                var len = data.users.length,
                    tmp = {};
                while(len--){
                    var user = data.users[len];
                    tmp[user.userId] = user;
                }
                $scope.users = tmp;
            });
        }

        $http.get('/api/getLocals').success(function (data, status, headers, config) {
            console.log(data);
            $scope.locals = data.locals;
        });
    }]
);