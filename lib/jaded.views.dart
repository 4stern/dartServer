import 'dart:isolate';
import 'package:jaded/runtime.dart';
import 'package:jaded/runtime.dart' as jade;

render(Map locals) {
  
var buf = [];
var self = locals;
if (self == null) self = {};
buf.add("<DOCTYPE html=\"html\"></DOCTYPE><html ng-app=\"yn\"><head lang=\"de\"><meta charset=\"UTF-8\"/><title>myTitle</title><script src=\"//ajax.googleapis.com/ajax/libs/angularjs/1.2.6/angular.min.js\"></script><script src=\"js/code.js\" type=\"text/javascript\"></script></head><body><h1>Data</h1><div ng-controller=\"statsController\"><ul><li ng-repeat=\"user in data.trending_users\" style=\"float:left; style:none;\"><img" + (jade.attrs({ 'src':("http://cdn2.younow.com/php/api/channel/getImage/channelId="+ '{{user.userId}}' +""), 'title':(""+'{{user.username}}'+" "+'{{user.viewers}}') }, {"src":true,"title":true})) + "/></li></ul></div></body></html>");;
return buf.join("");

}

main(List args, SendPort replyTo) {
  var html = render(args.first);
    replyTo.send(html.toString());
}
