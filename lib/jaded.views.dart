import 'dart:isolate';
import 'package:jaded/runtime.dart';
import 'package:jaded/runtime.dart' as jade;

render(Map locals) {
  
var buf = [];
var self = locals;
if (self == null) self = {};
buf.add("<DOCTYPE html=\"html\"></DOCTYPE><html ng-app=\"yn\"><head lang=\"de\"><meta charset=\"UTF-8\"/><title>younow monitor</title><script src=\"//ajax.googleapis.com/ajax/libs/angularjs/1.2.6/angular.min.js\"></script><script src=\"/asset/js/code.js\" type=\"text/javascript\"></script><link href=\"/asset/css/style.css\" rel=\"stylesheet\" type=\"text/css\"/></head><body ng-controller=\"statsController\"><div class=\"head\"><h1>YNM - YouNow Monitor</h1><p>Letzte Aktualisierung: 20.12.2015 20:30</p><h2><span class=\"list\">{{currents.local}}<div><ul><li ng-repeat=\"local in locals\" ng-click=\"switchLocal(local)\"><span>{{local}}</span></li></ul></div></span><span>#</span><span class=\"list\">{{currents.tag}}<div><ul><li ng-repeat=\"tag in tags\" ng-click=\"switchTag(tag.name)\"><span>{{tag.name}}</span></li></ul></div></span></h2></div><!--ul<li ng-repeat=\"tag in tags\"><span>{{tag.name}}</span></li>--><ul class=\"users\"><li" + (jade.attrs({ 'ng-repeat':("user in users"), 'style':("background: url(http://cdn2.younow.com/php/api/channel/getImage/channelId="+'{{user.userId}}'+");") }, {"ng-repeat":true,"style":true})) + "><a" + (jade.attrs({ 'ng-href':("http://www.younow.com/" + '{{user.profile}}'), 'target':("_blank"), 'style':("display:inline-block; width:100%; height:100%;") }, {"ng-href":true,"target":true,"style":true})) + "><!--img(src=\"http://cdn2.younow.com/php/api/channel/getImage/channelId=\" + '{{user.userId}}' + \"\", title=\"\" + '{{user.username}}' + \" \" + '{{user.viewers}}')--><span class=\"tagname\">{{user.username}}</span></a></li></ul><!--div.trendingUser<h2>trending user</h2><ul><li ng-repeat=\"user in data.trending_users\" style=\"float:left; style:none;\"><a" + (jade.attrs({ 'href':("http://www.younow.com/"+ '{{user.profile}}'), 'target':("_blank") }, {"href":true,"target":true})) + "><img" + (jade.attrs({ 'src':("http://cdn2.younow.com/php/api/channel/getImage/channelId=" + '{{user.userId}}' + ""), 'title':("" + '{{user.username}}' + " " + '{{user.viewers}}') }, {"src":true,"title":true})) + "/><span class=\"tagname\">{{user.tags[0]}}</span></a></li></ul>--><!--div(style=\"clear: both;\")--><!--div.trendingTags<h2>trending tags</h2><div><table><tr ng-repeat=\"tag in data.trending_tags\"><td>" + (jade.escape(null == (jade.interp = '#'+'{{tag.tag}}') ? "" : jade.interp)) + "</td></tr></table></div>--></body></html>");;
return buf.join("");

}

main(List args, SendPort replyTo) {
  var html = render(args.first);
    replyTo.send(html.toString());
}
