library server;

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:jaded/jaded.dart' as jade;

part 'core/Younow.dart';

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

        Timer s = new Timer.periodic(const Duration(milliseconds: 30000), refresh);


    }).catchError((e) => print(e.toString()));
}

