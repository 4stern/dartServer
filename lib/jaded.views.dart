import 'dart:isolate';
import 'package:jaded/runtime.dart';
import 'package:jaded/runtime.dart' as jade;

render(Map locals) {
  
var buf = [];
var self = locals;
if (self == null) self = {};
buf.add("<DOCTYPE html=\"html\"></DOCTYPE><html ng-app=\"yn\"><head lang=\"de\"><meta charset=\"UTF-8\"/><title>younow monitor</title><script src=\"//ajax.googleapis.com/ajax/libs/angularjs/1.2.6/angular.min.js\"></script><script src=\"/asset/js/code.js\" type=\"text/javascript\"></script><script src=\"/api/test/username/24\" type=\"text/javascript\"></script><link href=\"/asset/css/style.css\" rel=\"stylesheet\" type=\"text/css\"/></head><body><div ng-controller=\"statsController\"><div class=\"trendingUser\"><h2>trending user</h2><ul><li ng-repeat=\"user in data.trending_users\" style=\"float:left; style:none;\"><a" + (jade.attrs({ 'href':("http://www.younow.com/"+ '{{user.username}}'), 'target':("_blank") }, {"href":true,"target":true})) + "><img" + (jade.attrs({ 'src':("http://cdn2.younow.com/php/api/channel/getImage/channelId=" + '{{user.userId}}' + ""), 'title':("" + '{{user.username}}' + " " + '{{user.viewers}}') }, {"src":true,"title":true})) + "/><span class=\"tagname\">{{user.tags[0]}}</span></a></li></ul></div><div style=\"clear: both;\"></div><div class=\"trendingTags\"><h2>trending tags</h2><div><table><tr ng-repeat=\"tag in data.trending_tags\"><td>" + (jade.escape(null == (jade.interp = '#'+'{{tag.tag}}') ? "" : jade.interp)) + "</td><!--td(style=\"text-align: left;\") {{tag.score}}--></tr></table></div></div></div></body></html>");;
return buf.join("");

}

main(List args, SendPort replyTo) {
  var html = render(args.first);
    replyTo.send(html.toString());
}
