angular.module('yn', []).controller('statsController',
    ['$scope', '$http', function ($scope, $http) {

        $scope.currents={
            local: 'de',
            tag: 'german'
        };
        $scope.tags = [];
        $scope.locals = [];
        $scope.users = {};
        $scope.selectedUsers = [];

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

        $scope.addUserToSelection = function(user){
            if($scope.selectedUsers.indexOf(user)==-1){
                $scope.selectedUsers.push(user);
            }
        };
        $scope.removeUserFromSelection = function(user){
            var index = $scope.selectedUsers.indexOf(user);
            if (index > -1) {
                $scope.selectedUsers.splice(index, 1);
            }
        };

        function reloadTags(){
            var local = $scope.currents.local;
            $http.get('/api/getTags/'+local).success(function (data, status, headers, config) {
                $scope.tags = data.tags;
                $scope.tags.sort(function(a, b){
                    return b.score-a.score
                });
                $scope.switchTag($scope.tags[0].name);
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
                    if(!tmp[user.userId]){
                        tmp[user.userId] = {};
                    }
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