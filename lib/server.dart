library server;

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:jaded/jaded.dart' as jade;

part 'core/RouteController.dart';
part 'core/RouteProvider.dart';

part 'core/ResponseHandler.dart';
part 'core/JadeResponse.dart';
part 'core/JSONResponse.dart';
part 'core/FileResponse.dart';
part 'core/Younow.dart';


class ControllerURL1 extends RouteController {
    Map execute() {
        return {
            "foo":"sdsdsd"
        };
    }
}

class ControllerApiGetData extends RouteController {
    Younow yn;

    ControllerApiGetData(this.yn): super();

    Map execute() {
        return yn.getData();
    }
}

class ControllerEmpty extends RouteController {
}

main() {

    Younow yn = new Younow();
    Map data;

    HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 4040).then((HttpServer server) {
        print('listening on localhost, port ${server.port}');

        new RouteProvider(server, {
            "defaultRoute":"/url1",
            "staticContentRoot":"/asset"
        })
            ..route({
            "url": "/",
            "controller": new ControllerEmpty(),
            "response": new JadeResponse("views/index.jade")
        })
            ..route({
            "url": "/api/getData",
            "controller": new ControllerApiGetData(yn),
            "response": new JSONResponse("")
        })
            ..start();

        void refresh(dynamic) {
            yn.refreshData();
            data = yn.getData();
        }

        Timer s = new Timer.periodic(const Duration(milliseconds: 10000), refresh);


    }).catchError((e) => print(e.toString()));
}

