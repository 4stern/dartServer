part of server;

class ControllerTest extends RouteController {
	Future<Map> execute(Map params) {
		print('ControllerTest');
		print(params);
        var completer = new Completer();
        completer.complete(params);
        return completer.future;
    }
}