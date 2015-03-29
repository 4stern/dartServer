import 'dart:isolate';
import 'package:jaded/runtime.dart';
import 'package:jaded/runtime.dart' as jade;

render(Map locals) {
  
var buf = [];
var self = locals;
if (self == null) self = {};
buf.add("<DOCTYPE html=\"html\"></DOCTYPE><html ng-app=\"yn\"><head lang=\"de\"><meta charset=\"UTF-8\"/><title>younow monitor</title><script src=\"//ajax.googleapis.com/ajax/libs/angularjs/1.2.6/angular.min.js\"></script><script src=\"/asset/js/code.js\" type=\"text/javascript\"></script><link href=\"/asset/css/style.css\" rel=\"stylesheet\" type=\"text/css\"/></head><body ng-controller=\"statsController\"><div class=\"head\"><h1>YNM - YouNow Monitor</h1><p>Letzte Aktualisierung: 20.12.2015 20:30</p><h2><span class=\"list\">{{currents.local}}<div><ul><li ng-repeat=\"local in locals\" ng-click=\"switchLocal(local)\"><span>{{local}}</span></li></ul></div></span><span>#</span><span class=\"list\">{{currents.tag}}<div><ul><li ng-repeat=\"i in tags\" ng-click=\"switchTag(i.name)\"><span>{{i.name}}</span></li></ul></div></span></h2></div><!--ul<li ng-repeat=\"tag in tags\"><span>{{tag.name}}</span></li>--><ul class=\"users\"><li" + (jade.attrs({ 'ng-repeat':("user in users"), 'ng-click':("addUserToSelection(user)"), 'style':("background: url(http://cdn2.younow.com/php/api/channel/getImage/channelId="+'{{user.userId}}'+");") }, {"ng-repeat":true,"ng-click":true,"style":true})) + "><span class=\"tagname\">{{user.username}}</span></li></ul><div class=\"selectedusers\"><ul><li" + (jade.attrs({ 'ng-repeat':("user in selectedUsers"), 'ng-click':("removeUserFromSelection(user)"), 'style':("background: url(http://cdn2.younow.com/php/api/channel/getImage/channelId=" + '{{user.userId}}' + ") ;") }, {"ng-repeat":true,"ng-click":true,"style":true})) + "><span class=\"tagname\">{{user.username}}</span></li></ul></div></body></html>");;
return buf.join("");

}

main(List args, SendPort replyTo) {
  var html = render(args.first);
    replyTo.send(html.toString());
}
