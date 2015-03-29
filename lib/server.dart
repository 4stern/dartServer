library server;

import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:jaded/jaded.dart' as jade;
import 'younow/younow.dart';
import 'store/store.dart';

part 'core/RouteController.dart';
part 'core/RouteProvider.dart';

part 'core/ResponseHandler.dart';
part 'core/JadeResponse.dart';
part 'core/JSONResponse.dart';
part 'core/FileResponse.dart';

part 'core/controller/ControllerApiGetTags.dart';
part 'core/controller/ControllerApiGetData.dart';
part 'core/controller/ControllerApiGetLocals.dart';
part 'core/controller/ControllerApiGetUsers.dart';
part 'core/controller/ControllerEmpty.dart';
part 'core/controller/ControllerTest.dart';

main() {

    Map config = {
        "db":{
            "host": "localhost",
            "port": 3306,
            "user": "root",
            "password": "passap",
            "name": "younowmonitor"
        },
        "server" :{
            "port": 4040
        }
    };


    Younow yn = new Younow();
    PersistentProvider store = new PersistentProvider(config["db"]["host"], config["db"]["port"], config["db"]["user"], config["db"]["password"], config["db"]["name"] );
    Map data;
    Duration interval = const Duration(minutes: 10);

    HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, config["server"]["port"]).then((HttpServer server) {
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
                "url": "/api/test/:user/:id",
                "controller": new ControllerTest(),
                "response": new JSONResponse("")
            })
            ..route({
                "url": "/api/getData",
                "controller": new ControllerApiGetData(yn),
                "response": new JSONResponse("")
            })
            ..route({
                "url": "/api/getTags/:local",
                "controller": new ControllerApiGetTags(store),
                "response": new JSONResponse("")
            })
            ..route({
                "url": "/api/users/:local/:tag",
                "controller": new ControllerApiGetUsers(store),
                "response": new JSONResponse("")
            })
            ..route({
                "url": "/api/getLocals",
                "controller": new ControllerApiGetLocals(store),
                "response": new JSONResponse("")
            })
            ..start();

        //start getting younow data per interval 
        new Timer.periodic(interval, (dynamic) {
            /*
                1. get all locals
                2. for each local
                    A) get tags
                        I.) for each tag
                            a) get users

            */
            print('refreshing data... ');
            try{
                yn.getLocals().then((locals){
                    locals.forEach((local){
                        yn.getTags(local).then((tags){
                            store.appendTags(local, tags);
                            tags.forEach((tag){
                                yn.getChannelId(local, tag.name).then((channelId){
                                    yn.getUsers(channelId).then((users){
                                        store.appendUsers(tag.name, users);
                                    });
                                });
                            });
                        });
                    });
                });
            }catch(e){
                print(e);
            }
        });

    }).catchError((e) => print(e.toString()));
}

