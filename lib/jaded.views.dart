import 'dart:isolate';
import 'package:jaded/runtime.dart';
import 'package:jaded/runtime.dart' as jade;

render(Map locals) {
  var foo = locals['foo'];

var buf = [];
var self = locals;
if (self == null) self = {};
buf.add("<DOCTYPE html=\"html\"></DOCTYPE><html><head lang=\"de\"><meta charset=\"UTF-8\"/><title>myTitle</title></head><body><h1>" + (jade.escape(null == (jade.interp = foo) ? "" : jade.interp)) + "</h1><a href=\"/url2\">next1</a></body></html>");;
return buf.join("");

}

main(List args, SendPort replyTo) {
  var html = render(args.first);
    replyTo.send(html.toString());
}
