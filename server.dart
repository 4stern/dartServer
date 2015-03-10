library server;

import 'dart:io';
import 'packages/json/json.dart';


abstract class RouteController{
	RouteHandler();
	String execute(){
		return 'route not implemented yet!';
	}
}

class ControllerURL1 extends RouteController{
	String execute(){
		return 'route /url1 yeah';
	}
}

class ControllerURL2 extends RouteController{
}

class RouteProvider{
	HttpServer server;
	Map<String, RouteController> routeControllers = new Map();
	Map cfg;

	RouteProvider(this.server, this.cfg);

	void route(String url, Map cfg){
		print('added route: '+ url);
		routeControllers[url] = cfg["controller"];
	}

	void start(){
		server.listen(this.handleRequest);
	}

	void handleRequest(HttpRequest request){
		String path = request.uri.path;
		print('incomming request: '+path);

		if(routeControllers.containsKey(path)){
			String body = routeControllers[path].execute();
			request.response.write(body);
			request.response.close();
		} else {
			request.response.redirect(this.cfg["defaultRoute"]);
		}
	}
}

main() {
	HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 4040).then((HttpServer server) {
		print('listening on localhost, port ${server.port}');
		new RouteProvider(server,{
			"defaultRoute":"/url1"
		})
		..route('/url1', {
			"template": "/templates/url1.html",
			"controller": new ControllerURL1()
		})
		..route('/url2',{
			"template": "/templates/url2.html",
			"controller": new ControllerURL2()
		})
		..start();

  	}).catchError((e) => print(e.toString()));
}

