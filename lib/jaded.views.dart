import 'dart:isolate';
import 'package:jaded/runtime.dart';
import 'package:jaded/runtime.dart' as jade;

render(Map locals) {
  
var buf = [];
var self = locals;
if (self == null) self = {};
buf.add("<DOCTYPE html=\"html\"></DOCTYPE><html ng-app=\"yn\"><head lang=\"de\"><meta charset=\"UTF-8\"/><title>myTitle</title><script src=\"//ajax.googleapis.com/ajax/libs/angularjs/1.2.6/angular.min.js\"></script><script src=\"js/code.js\" type=\"text/javascript\"></script><style>li{\n    position: relative;\n}\nli span.tagname{\n  position: absolute;\n  background: white;\n  left: 0px;\n  width: 100%;\n  height: 25px;\n  text-align: center;\n  bottom: 0px;\n  padding-top: 8px;\n  display: none;\n}\nli:hover span.tagname{\n    display: block;\n}</style></head><body><h1>Data</h1><div ng-controller=\"statsController\"><ul><li ng-repeat=\"user in data.trending_users\" style=\"float:left; style:none;\"><img" + (jade.attrs({ 'src':("http://cdn2.younow.com/php/api/channel/getImage/channelId="+ '{{user.userId}}' +""), 'title':(""+'{{user.username}}'+" "+'{{user.viewers}}') }, {"src":true,"title":true})) + "/><span class=\"tagname\">{{user.tags[0]}}</span></li></ul><div style=\"clear: both;\"></div><table><tr ng-repeat=\"tag in data.trending_tags\"><td>{{tag.tag}}</td><td style=\"text-align: left;\">{{tag.score}}</td></tr></table></div></body></html>");;
return buf.join("");

}

main(List args, SendPort replyTo) {
  var html = render(args.first);
    replyTo.send(html.toString());
}
