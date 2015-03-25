part of server;

class ControllerTest extends RouteController {
	Map execute(Map params) {
		print('ControllerTest');
		print(params);
        return params;
    }
}