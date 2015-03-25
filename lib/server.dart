library server;

import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:jaded/jaded.dart' as jade;
import 'package:younow/younow.dart';

part 'core/RouteController.dart';
part 'core/RouteProvider.dart';

part 'core/ResponseHandler.dart';
part 'core/JadeResponse.dart';
part 'core/JSONResponse.dart';
part 'core/FileResponse.dart';

part 'core/controller/ControllerApiGetData.dart';
part 'core/controller/ControllerEmpty.dart';

main() {
    Younow yn = new Younow();
    Map data;
    int refreshTime = 30000;

    HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 4040).then((HttpServer server) {
        print('listening on localhost, port ${server.port}');

        //start webserver
        new RouteProvider(server, {
            "defaultRoute":"/",
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

        //start getting younow data per interval 
        new Timer.periodic(const Duration(milliseconds: refreshTime), (dynamic) {
            yn.refreshData();
            data = yn.getData();
        });

    }).catchError((e) => print(e.toString()));
}

