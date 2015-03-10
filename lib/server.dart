library server;

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:jaded/jaded.dart' as jade;

part 'core/RouteController.dart';
part 'core/RouteProvider.dart';

part 'core/ResponseHandler.dart';
part 'core/JadeResponse.dart';


class ControllerURL1 extends RouteController {
  Map execute() {
    return {
      "foo":"sdsdsd"
    };
  }
}

class ControllerURL2 extends RouteController {
}



main() {
  HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 4040).then((HttpServer server) {
    print('listening on localhost, port ${server.port}');

    new RouteProvider(server, {
        "defaultRoute":"/url1"
    })
    ..route({
      "url": "/url1",
      "controller": new ControllerURL1(),
      "response": new JadeResponse("/views/test.jade")
    })
    ..route({
      "url": "/url2",
      "controller": new ControllerURL2(),
      "response": new JadeResponse("/views/test2.jade")
    })
    ..start();

  }).catchError((e) => print(e.toString()));
}

