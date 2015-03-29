part of server;

class ControllerApiGetData extends RouteController {
    Younow yn;

    ControllerApiGetData(this.yn): super();

    Future<Map> execute(Map params) {
        var completer = new Completer();
        completer.complete(yn.getRowData());
        return completer.future;
    }
}