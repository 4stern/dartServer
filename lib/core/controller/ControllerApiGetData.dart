part of server;

class ControllerApiGetData extends RouteController {
    Younow yn;

    ControllerApiGetData(this.yn): super();

    Map execute() {
        return yn.getData();
    }
}